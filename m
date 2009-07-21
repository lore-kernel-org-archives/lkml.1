Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZGUQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZGUQuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZGUQuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:50:11 -0400
Received: from main.gmane.org ([80.91.229.2]:45061 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbZGUQuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:50:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: problems debugging panic with gdb, kdump, and vmcore
Date: Tue, 21 Jul 2009 10:52:03 -0600
Message-ID: <4A65F233.9030605@gmail.com>
References: <f488382f0907202146m6d124de9w19c13222690718b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
In-Reply-To: <f488382f0907202146m6d124de9w19c13222690718b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 10:46 PM, Steven Noonan wrote:
> Hi folks,
>
> I've got a kernel panic that is easily reproducible (I am 99% sure
> that 2.6.30.2 itself isn't to blame, it's the out-of-tree drm module I
> built from here: http://cgit.freedesktop.org/mesa/drm/). I could just
> follow the stack trace, but I'd like to learn how to use kexec/kdump
> to debug this. So far, I've got kexec successfully loading a kernel on
> a panic, and I'm able to copy the vmcore out of /proc to someplace
> permanent, but trying to use gdb on it gives very strange results. I
> don't know what I'm doing wrong. I've rebuilt the kernel multiple
> times and ensured that ccache is cleared each time just in case that
> might interfere. Here's what I'm getting with gdb:
>
>
> Alcarin linux # pwd
> /usr/src/linux
> Alcarin linux # gdb vmlinux /var/tmp/vmcore
> GNU gdb 6.8
> Copyright (C) 2008 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later<http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "i686-pc-linux-gnu"...
>
> warning: exec file is newer than core file.

Why is the vmlinux file newer than the vmcore file?

