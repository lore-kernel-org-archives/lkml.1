Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZAPU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZAPU43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZAPU4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:56:21 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:40939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZAPU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:56:20 -0500
Message-ID: <4970F46F.4060803@gawab.com>
Date: Fri, 16 Jan 2009 12:56:15 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc1 Firefox crashing on page load
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the weirdest crash I've come across related to an rc kernel.
First I tested .29-rc1 when it came out and firefox crashed only when 
clicking on certain links.
Now I updated my tree and compiled another kernel. This time firefox 
crashes right after it finishes loading my homepage.
This happens every time, and has never happened on any kernel before.

I did a strace of firefox and these are the last few lines that are 
always present before it crashes:

gettimeofday({1232129663, 344658}, NULL) = 0
gettimeofday({1232129663, 351300}, NULL) = 0
open(\"/home/justin/.mailcap\", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No 
such file or directory)
time(NULL)                              = 1232129663
stat64(\"/home/justin/.gnome2/vfs/modules\", 0xbfec4efc) = -1 ENOENT (No 
such file or directory)
stat64(\"/etc/gnome-vfs-2.0/modules\", {st_mode=S_IFDIR|0755, 
st_size=128, ...}) = 0
geteuid32()                             = 1000
getegid32()                             = 1000
getuid32()                              = 1000
tgkill(4615, 4642, SIGRT_1upeek: ptrace(PTRACE_PEEKUSER,4615,44,0): No 
such process

So far I've tried other programs, but I haven't seen any other crashes.
More information about my computer (including: dmesg, config, sysinfo) 
can be found at:
http://jdserver.homelinux.org/bugreports/

Justin Madru
