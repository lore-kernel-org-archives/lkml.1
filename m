Return-Path: <linux-kernel-owner+w=401wt.eu-S2992967AbXDDPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992967AbXDDPi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992966AbXDDPi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:38:27 -0400
Received: from bay0-omc3-s36.bay0.hotmail.com ([65.54.246.236]:54561 "EHLO
	bay0-omc3-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992967AbXDDPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:38:26 -0400
Message-ID: <BAY113-DAV124C8565330DC6C51B2B09B9660@phx.gbl>
X-Originating-IP: [128.100.5.117]
X-Originating-Email: [gonwg@hotmail.com]
From: "Michael" <gonwg@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: set up new kernel with grub
Date: Wed, 4 Apr 2007 11:36:23 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2962
X-OriginalArrivalTime: 04 Apr 2007 15:38:25.0764 (UTC) FILETIME=[48F48240:01C776CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I compiled a new kernel: 2.6.20.3, and hope to test it without removing 
my old kernel.

Here is what I did by following 
http://searchenterpriselinux.techtarget.com/tip/0,289483,sid39_gci1204148,00.html :

I built the kernel in a local directory, say "mydir", with kernel 
"bzImage-2.6.20.3" and map file "System.map".

>su          (#become a root)

>cp mydir/bzImage-2.6.20.3 /boot/bzImage-2.6.20.3
>cp mydir/System.map /boot/System.map-2.6.20.3

>cd /boot
>ln -s /boot/bzImage-2.6.20.3 /boot/bzImage
>ln -s /boot/System.map-2.6.20.3 /boot/System.map

>vi grub/menu.lst

add a new entry as
**************************************
title Red Hat Linux (2.6.20.3)
    root (hd0, 0)
    kernel /boot/bzImage ro root=LABEL=/
    initrd /boot/initrd-2.6.20.3.img
**************************************

>create an initial ram disk image by
mkinitrd -k /boot/bzImage -i /boot/initrd-2.6.20.3

It reports wrong usage of "mkinitrd", and no initrd-2.6.20.3.img is 
created.

Any idea about what's wrong with the "mkinitrd" command ?


Thanks.

Mike

