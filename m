Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZKURlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZKURlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZKURlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:41:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47636 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZKURly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:41:54 -0500
Message-ID: <4B082663.2010905@w1an.in>
Date: Sat, 21 Nov 2009 09:41:55 -0800
From: Balaji Ravindran <b@w1an.in>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Kernel compilation Question
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I tried compiling the wireless 2.6 kernel on my debian machine using
make-kpkg and being lazy, i just did make defconfig, and saw that my
compilation went fine without any issues, but i noticed that there was
no ramdisk image that was generated when i installed the linux-image*.deb.

i did use --initrd option,

Was it because, using make defconfig compiles everything on the kernel
itself? Aren't there any 'm' option in defaults?(dunno just asking if
this is the case)

or did i miss something out

Please see if i missed some step

Summary of steps performed.

extracted wireless 2.6 source onto /usr/src

created symbolic link

make defconfig (i did not copy my existing config file to .config, i
just wanted to try out make defconfig option)

make-kpkg --initrd --append-to-version=foo --revision=bar kernel_image
modules_image kernel_headers

this created 2 files linux-image* and linux-headers*, i was missing the
modules image also(but that was a second question)

did dpkg -i linux-image*

updated grub and placed files in /boot, but did not create initrd image.
Why is that?

Thanks

Balaji R
