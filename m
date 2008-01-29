Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbYA2RQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbYA2RQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764759AbYA2RQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:16:08 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:52288 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbYA2RQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:16:05 -0500
Date: Tue, 29 Jan 2008 12:12:03 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479F5B39.1000708@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Florian Attenberger <valdyn@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Message-id: <200801291212.03910.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801291004.12565.gene.heskett@gmail.com> <479F5B39.1000708@garzik.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008, Jeff Garzik wrote:
>Gene Heskett wrote:
>> Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' number
>> when dmesg says its found ok at ata2.00?  I've turned on an option that
>> says something about using the bios for device access this build, but I'll
>> be surprised if that's it. :)
>
>I think you mean /dev/scdx not /dev/sdx.  Make sure you have the 'sr'
>driver compiled and load (CONFIG_BLK_DEV_SR).
>
That menu item COULD be moved, I don't have any REAL scsi stuff, so I didn't 
look there.  My bad, with help from hiding it like that. :-)

>The bios-for-dev-access thing definitely won't help, and may hurt (by
>taking over the device you wanted to test).
>
Ok, if BLK_DEV_SR fails, I'll take that back out.  I'm heating the room making 
kernels here. :)

Thanks Jeff.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Life sucks, but death doesn't put out at all.
		-- Thomas J. Kopp
