Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKOKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKOKjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZKOKjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:39:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZKOKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:39:53 -0500
Message-ID: <4AFFDA7C.6010907@cv-sv.de>
Date: Sun, 15 Nov 2009 11:39:56 +0100
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4) Gecko/20091017 SUSE/2.0.0-3.1 SeaMonkey/2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Does a kernel assisted file system reorder make sense?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+jwM8yu+Fw13lURw94X/Vko16fyYrhNQy9yUD
 0kZh3I7I93Zk0Hl4tSalk1hSBzvm+BTW6BxwcmhOjhXFaY0vX0
 y75JUstal1Z9reptoIiJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just have read some articles about faster booting systems
(Ubuntu 9.10) , SSD, hard disks, latency and seek times...

Due to this I have some ideas which I like to discuss.
I am for sure not the first with this idea, but I do not
find any discussion about it. :)

Shouldn't it be possible for the kernel to provide an ordered
loaded block list read from disk ? This could be used for a kind
of "forced reorder" for a file system tool.

May be this would also fasten the system start from a hard disk.
I could imagine a scenario like:
- kernel start (boot loader )
- kernel to keep a list of the read blocks (on a per filesystem base)
- kernel to log this list just before init starts.
- on demand: kernel to continue the recording
- on demand: kernel can signaled to log this list.
   (e.g. graphic log in ready )

This logged list could be use from a new tool like "e2reorder"
for ext2/3/4 to reorder the blocks within the file system(s) to
reduce the seek delay for a start from a hard disk.

The logged list could also be used as a "to load/cache first" list
for the kernel/initrd boot. This might fasten the start without
special file system tools or for file systems without support.

But this would only make sense if a system boot is delayed by
hard disk seek times. I have no SSD to check if a SSD boots
faster. Does anyone have the experience if a SSD boots faster?

Best regards,

Christian


