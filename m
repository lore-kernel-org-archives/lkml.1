Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXLIHas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXLIHas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXLIHal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:30:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:49512 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXLIHak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aNjXwLX15NQd0oIBnKc1SOogSsNISos9dKIuhvIkFu7UOtRZjM9k/zJ8ocHebaZQ2eRlvFSPup5Ylm3ov3BwldiTn9bNxj8lvCqrKI2FAgWqcXXFcZPgUzsEMettaFKoCk+rXbfAeL1xe4ksYwlCXJNIEs9bVOoXu+rRUrc+h+I=
Message-ID: <475B9978.3080606@googlemail.com>
Date: Sun, 09 Dec 2007 08:30:00 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: usb regression in 2.6.24-rc4
References: <200712090113.57805.gene.heskett@gmail.cm>
In-Reply-To: <200712090113.57805.gene.heskett@gmail.cm>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings guys & gals;

Hi ,

> 
> This was sent about an hour ago to the usb-devel list also.
> -------------
> Just a few minutes ago I needed to make use of my scanner, an Epson 1250u.
> 
> Firing up xsane, the usual select the device menu window didn't show, and it 
> went straight to my tv card as the only input device.
> 
> I couldn't recall the name of the tool that scans for scanners that's in the 
> sane package, or should be, so I then did an lsusb, but got an empty result!
> 
> Unplugging the usb cable from the scanner, then reconnecting the usb cable got 
> me the usual disconnect and connect messages in the log, but xsane still 
> couldn't find it.
> 
> So I rebooted to 2.6.24-rc4 again, same result.  lsusb still gave an empty 
> result.  The two kernels were generated from the same .config as far as I 
> know.  The -rc3 .config was fed to a "make oldconfig" to make 
> the -rc4 .config as is the usual practice.
> 
> So I then rebooted to 2.6.24-rc3, and it all works again.  I got the scanning 
> done and the pix sent on their merry way.
> 
> Anybody have a suggestion of what to check, or maybe a patch to revert?  Or 
> a .config option that needs to be enabled?
>

Sounds for me like this one : 

http://lkml.org/lkml/2007/12/6/409

Gabriel
