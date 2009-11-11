Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZKKRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZKKRhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbZKKRhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:37:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:38284 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbZKKRhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=N6zkM13Vu0TukTp+D230+L9DTEoWiYJEZC392K2flIDVL0zX8BX9WzIv21ILeTJKZg
         LgrBfOKKg5qAy3V2pln4PDgkohhL7PG5oRdGzRlvPCkxz9Vk750ifalnaYC/OlvHN17h
         SnkTvdkOjv+JjhbMtVX3Gqs243uieNuhxAxIs=
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 18:31:41 +0100
Message-ID: <40a4ed590911110931q11b85c7ai1fb50b7545241a7@mail.gmail.com>
Subject: Second IDE device not found with Kernel 2.6.31.6
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have an old (5 years) machine that has two IDE disks inside. It
normally runs on a SW-raid 1. I done a fresh install because of gcc.
Then I installed Kernel 2.6.31.6 and when I boot the machine with both
IDE disks (ide0 and ide1) attached I get a "VFS boot partition not
found" error as long as I do not connect the CD-Rom to the ide0 slave.
If I connect the CD-Rom to the primary slave the kernel boots - but -
the second master at ide1 is not found by the kernel at boot-up.

If I boot from gentoo-CD with Kernel 2.6.30 on it, both HDDs are found
and can be worked on (mkfs.jfs).

My ordeal can be found here:

http://trac.ywesee.com/ticket/133#comment:28

Motherboard is an ASUS TR-DLS - I updated the BIOS to the latest version (1006).

I also found that in 2.6.27.39 there is an option "Enhanced
IDE/MFM/RLL disk/cdrom/tape/floppy support. It says if you have more
then one IDE disk say Y or M here".

Where is that option in 2.6.31.6?

Any hints are welcome.

Please CC me. I am not on the list.

Best
Zeno
