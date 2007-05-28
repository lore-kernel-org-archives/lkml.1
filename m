Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbXE1Lie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbXE1Lie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXE1Li0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:38:26 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:57628 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXE1Li0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:38:26 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <1180351493.4242.31.camel@lov.localdomain>
References: <200705272229.21263.rjw@sisk.pl>  <20070527220412.GC22687@srcf.ucam.org>  <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl>  <20070528111554.GF18807@elf.ucw.cz> <1180351493.4242.31.camel@lov.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6BFA837E-47D4-487F-9D71-FA83D6D865E5@cam.ac.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 12:38:23 +0100
To: Kay Sievers <kay.sievers@vrfy.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2007, at 12:24, Kay Sievers wrote:

> A driver for a bootup-critical device like this should just never
> release the firmware after the first load. There is absolutely no  
> point
> in doing that.

Bogus argument: is a USB-Ethernet device which needs firmware loading  
boot-up critical? Not on the surface, but if the device loads root  
over this device, it suddenly is.

This functionality should also be written into the firmware-class  
(and this fact *is* acknowledged in the sparse documentation).

Michael-Luke Jones
