Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXD0PJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXD0PJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXD0PJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:09:14 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:35341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbXD0PJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BWkjk1ALrgDdvh5c30ymeHxvySd7INwArAeGrYeMKmQdRo5AP0XLMOAsfWq+SkDTyZDy1yEINhfQ9v0iYsA+kGvrZjVRwoJmReWhZjmLgYkxWc6QccB5W3Fiz9S1/fQ0561SUr0lhCEVy9EhCSJqjhqg6p8J1U7hsBPP3pnB5U0=
Message-ID: <8355959a0704270809i1de3766elbc54c7ede5f421db@mail.gmail.com>
Date: Fri, 27 Apr 2007 20:39:11 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Video for Linux deprecated drivers (VIDEO_V4L1)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I need add a device for a particular solution on a x86 box. Device is
Logitech QuickCam, USB based WebCam (has to be included because of the
change in the experiment specs).

To get the device working (capture images by a V4L application), need
to compile the driver (qc-usb) & insert the quickcam.ko module. But,
what the requirement says I need to enable the VIDEO_V4L1 support.
Then I need to select USB_QUICKCAM_MESSENGER driver under the V4L USB
devices. Till here it's fine.

But if I look at the kernel config, VIDEO_V4L1 is deprecated. If I
decide to enable VIDEO_V4L1_COMPAT, there isn't any
USB_QUICKCAM_MESSENGER driver under the V4L USB devices!

Should I select the VIDEO_V4L1 support to get the WebCam working or is
there any other way (work around) to get my WebCam working with
VIDEO_V4L1_COMPAT? Comments pl?

~Akula2
