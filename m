Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYGNIpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYGNIpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYGNIpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 04:45:11 -0400
Received: from india.einfochips.com ([203.88.139.151]:30191 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755334AbYGNIpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 04:45:09 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 04:45:09 EDT
Message-ID: <487B12EA.3020907@einfochips.com>
Date: Mon, 14 Jul 2008 14:18:42 +0530
From: Dhruval Shah <dhruval.shah@einfochips.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ext3 filesystem error: ext3_get_inode_block: group >= groups count
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on an Embedded System in which I have a Compact Flash and 
Linux(2.6.11) with EXT3 file system on Compact Flash.
Recently I changed my file system attributes to "sync" in "/etc/fstab" 
and then I am facing issue.

What I conclude after debugging is that when the application is writing 
to the file which is in /dev/hda8 (we have IDE interface with the CF) 
and if the system's power goes off abruptly then the next time when the 
system is booting it complains while mounting the /dev/hda8 partition that:
*[root@admin ~]# mount /dev/hda8 tmp/
mount: wrong fs type, bad option, bad superblock on /dev/hda8,
       or too many mounted file systems
[root@admin ~]#           
*
dmesg showed me this:
*EXT3-fs error (device hda8): ext3_get_inode_block: group >= groups count
EXT3-fs: invalid journal inode.
*
I tried to run fsck and e2fsck as well but it didn't solve the problem.

I have seen that some patch to the kernel is around for ignoring this 
error but I am not sure whether this is the genuine problem or I can 
apply the patch to my kernel and ignore it.

I wish to be personally CC'ed the answers/comments posted to the list in 
response to this posting.

Thanks,
Dhruval


-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
__________________________________________________________________________
 
