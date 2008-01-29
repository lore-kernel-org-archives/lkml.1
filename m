Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYA2RcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYA2RcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYA2RcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:32:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44659 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYA2RcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:32:07 -0500
Message-ID: <479F6314.6090906@garzik.org>
Date: Tue, 29 Jan 2008 12:32:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Florian Attenberger <valdyn@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801291004.12565.gene.heskett@gmail.com> <479F5B39.1000708@garzik.org> <200801291212.03910.gene.heskett@gmail.com>
In-Reply-To: <200801291212.03910.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Tuesday 29 January 2008, Jeff Garzik wrote:
>> Gene Heskett wrote:
>>> Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' number
>>> when dmesg says its found ok at ata2.00?  I've turned on an option that
>>> says something about using the bios for device access this build, but I'll
>>> be surprised if that's it. :)
>> I think you mean /dev/scdx not /dev/sdx.  Make sure you have the 'sr'
>> driver compiled and load (CONFIG_BLK_DEV_SR).
>>
> That menu item COULD be moved, I don't have any REAL scsi stuff, so I didn't 
> look there.  My bad, with help from hiding it like that. :-)
> 
>> The bios-for-dev-access thing definitely won't help, and may hurt (by
>> taking over the device you wanted to test).
>>
> Ok, if BLK_DEV_SR fails, I'll take that back out.  I'm heating the room making 
> kernels here. :)

I can say with 100% certainty that 'sr' is required in order to use your 
dvd writer with libata.  :)

	Jeff



