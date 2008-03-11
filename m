Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbYCKXfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbYCKXfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYCKXfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:35:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:14491 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYCKXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pX/1qbqhybF40SdpeDeCnee+MNVaPGZMFwDvlkl123cyCauwNOcKns0a67rav6XOVIcVhq2KPwlxe0itoyEuBZuae6Y6a/4Ryy0bQwqIUo8Ti19e8ngkUdaww/aUCCbyRKYF5IMz5I24TwlgJAYeas2iatE5zu0WZXRTdr+QMpU=
Message-ID: <f188924b0803111635k42a186c6nc616fa05a830d9b7@mail.gmail.com>
Date: Wed, 12 Mar 2008 00:35:36 +0100
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: EXT3-fs error corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running Ubuntu 8.04 "Hardy Heron" (alpha).

MSI P35 Neo
Samsung SpinPoint T166 500 gb (7200 rpm, SATA-2, 16 mb cache)
Samsung SpinPoint T166 250 gb (7200 rpm, SATA-2, 16 mb cache)

sda1 = Windows XP
sdb1 = Linux

So I am listening to MP3 music in Rhythmbox 0.11.4, and surfing with
Mozilla Firefox 3.0b3 and perhaps doing some other stuff, like maybe
running apt-update && upgrade && clean && autoclean && autoremove or
something in a Terminal or something.

And then my computer becomes unresponsive. The HDD LED shine all the
time on the computer case.

Then I do Ctrl+Alt+F2 and try to login, and I type my username and
press enter, and it waits there for a while, then it start spit some
error messages, and wont let me in.

Like:
EXT3-fs error (device sdb1): ext3_get_inode_loc: unable to read node
block - inode=1599522, block=3211298
And it can spam the console with that kind of stuff.

Then I shut down the computer (by PSU switch), restart and it borked out again.
Shut down computer by PSU switch again, and runned HUTIL v2.10 by
Samsung, a disk diagnostic tool that checks SMART, does disk spin up,
spin down, read surface scan, and couple other diagnostic stuff. It
reported no errors, and said the disk were okay.

Then I rebooted into my old Ubuntu 7.04 "Gutsy Gibbon" LiveCD and run
some commands to fix it.
$ sudo e2fsck -pcf /dev/sdb1
$ sudo badblocks -sv /dev/sdb1

After that, computer worked again.
But today (next day), my computer borked out again.
In the same way and started spitting out error messages...

[20061.478996] journal commit I/O error
[numbers] EXT3-fs error (device sdb1): ext3_find_entry: reading
directory #2399041 offset 0

and stuff like:
[numbers] EXT3-fs error (device sdb1): ext3_reserve_inode_write:
Journal has aborted

It happened when I was using the 2.6.24-11-386 kernel.
I am scared, I don't know if my hard disk maybe is broken. Samsung's
HUTIL said the hard disk was okay.
But now it happened more than once, and maybe its a bug in the kernel,
or ext3 file system? I don't know. =/

Mar 9 16:46:06 ubuntu kernel: [ 25.735768] ext3_orphan_cleanup:
deleting unreferenced inode 1485173
Mar 9 16:46:06 ubuntu kernel: [ 25.735786] ext3_orphan_cleanup:
deleting unreferenced inode 1501809
Mar 9 16:46:06 ubuntu kernel: [ 25.735794] ext3_orphan_cleanup:
deleting unreferenced inode 1501680
Mar 9 16:46:06 ubuntu kernel: [ 25.735799] ext3_orphan_cleanup:
deleting unreferenced inode 1501678
Mar 9 16:46:06 ubuntu kernel: [ 25.735803] ext3_orphan_cleanup:
deleting unreferenced inode 1501677
Mar 9 16:46:06 ubuntu kernel: [ 25.735808] ext3_orphan_cleanup:
deleting unreferenced inode 1501676
Mar 9 16:46:06 ubuntu kernel: [ 25.735812] ext3_orphan_cleanup:
deleting unreferenced inode 1501675
Mar 9 16:46:06 ubuntu kernel: [ 25.735816] ext3_orphan_cleanup:
deleting unreferenced inode 1501674
Mar 9 16:46:06 ubuntu kernel: [ 25.735821] ext3_orphan_cleanup:
deleting unreferenced inode 1501673
Mar 9 16:46:06 ubuntu kernel: [ 25.735825] ext3_orphan_cleanup:
deleting unreferenced inode 1501672
Mar 9 16:46:06 ubuntu kernel: [ 25.735830] ext3_orphan_cleanup:
deleting unreferenced inode 1501671
Mar 9 16:46:06 ubuntu kernel: [ 25.735834] ext3_orphan_cleanup:
deleting unreferenced inode 1501669
Mar 9 16:46:06 ubuntu kernel: [ 25.735838] ext3_orphan_cleanup:
deleting unreferenced inode 1501668
Mar 9 16:46:06 ubuntu kernel: [ 25.735843] ext3_orphan_cleanup:
deleting unreferenced inode 1501667
Mar 9 16:46:06 ubuntu kernel: [ 25.746330] ext3_orphan_cleanup:
deleting unreferenced inode 1501666
Mar 9 16:46:06 ubuntu kernel: [ 25.746336] ext3_orphan_cleanup:
deleting unreferenced inode 1338406
Mar 9 16:46:06 ubuntu kernel: [ 25.750996] ext3_orphan_cleanup:
deleting unreferenced inode 1504210
Mar 9 16:46:06 ubuntu kernel: [ 25.751001] ext3_orphan_cleanup:
deleting unreferenced inode 1504199
Mar 9 16:46:06 ubuntu kernel: [ 25.751006] ext3_orphan_cleanup:
deleting unreferenced inode 1504191
Mar 9 16:46:06 ubuntu kernel: [ 25.756010] ext3_orphan_cleanup:
deleting unreferenced inode 2872358
Mar 9 16:46:06 ubuntu kernel: [ 25.756019] ext3_orphan_cleanup:
deleting unreferenced inode 1338610
Mar 9 16:46:06 ubuntu kernel: [ 25.756024] ext3_orphan_cleanup:
deleting unreferenced inode 1338441
Mar 9 16:46:06 ubuntu kernel: [ 25.762751] ext3_orphan_cleanup:
deleting unreferenced inode 2415376

https://bugs.launchpad.net/ubuntu/+bug/200747

I would like to get sent a reply to my email, since i don't subscribe
to this list.
