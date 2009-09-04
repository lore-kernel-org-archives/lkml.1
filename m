Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZIDFRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZIDFRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZIDFRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:17:33 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8228 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZIDFRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:17:33 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=8pif782wAAAA:8
 a=gEbR8-eWmScaGpknTf4A:9 a=fN_nl2-gCVduG-hcaIUA:7
 a=gUbh4eu6hkP9aI0J5CGQhbM6MTgA:4 a=MSl-tDqOz04A:10
Date: Thu, 03 Sep 2009 23:17:34 -0600
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: mvsas issues
In-reply-to: <72dbd3150909031732p76275c83hc43ca30601be3e53@mail.gmail.com>
To: David Rees <drees76@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <ccdefeca5c690.4aa04e8e@shaw.ca>
MIME-version: 1.0
X-Mailer: Sun Java(tm) System Messenger Express 6.2-7.05 (built Sep  5 2006)
Content-type: text/plain; charset=iso-8859-1
Content-language: en
Content-transfer-encoding: 8BIT
Content-disposition: inline
X-Accept-Language: en
References: <200909031809.58107.tfjellstrom@shaw.ca>
 <72dbd3150909031732p76275c83hc43ca30601be3e53@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
From: David Rees <drees76@gmail.com>
Date: Thursday, September 3, 2009 6:32 pm
Subject: Re: mvsas issues
To: tfjellstrom@shaw.ca
Cc: linux-kernel@vger.kernel.org

> On Thu, Sep 3, 2009 at 5:09 PM, Thomas 
> Fjellstrom<tfjellstrom@shaw.ca> wrote:
> > I just got a Marvell SAS card, And I've been trying to copy 
> one set of disks
> > over to another before one of the drives dies for good...
> 
> Have you tried using one of the rescue oriented versions of dd 
> to make
> a copy of the failing disk?  Then copy the image to a good 
> disk and
> recreate your array (do it in read-only mode!) and see what you can
> recover.
>

I haven't yet, with 2.6.30, there doesn't seem to be an mvsas driver, in 2.6.31-rc5 it OOPSes the kernel, and in 2.6.31.-rc8 it locks up the entire marvell controller (That is all ports start returning errors) so ALL drives on it are useless. One additional problem is the drive thats giving up the ghost is one of two 2TB disks thats in a temporary md raid0 array. The rest of my disks are all 1TB or smaller. Trying to backup one half of the raid0 pair to a couple separate 1TB disks would be a pain to say the least. And last, but not least, today the drive was decideing to error out after 10 minutes of any kind of actual use. It works after boot for a while no matter which controller its on, but after a bit of load it croaks.

I've decided to give the system and the drive a rest for tonight and try to get it backed up in the morning. Its possible the temperature here was causing the drive to get a little too warm (60c+?). Its strange though. The drive can last 12 hours as long as the load is very light. I might get some ata errors, but nothing libata can't handle with a reset (it causes a brief pause, but stuff keeps going), but the more I try to do, the faster it decides to throw an error. The errors I got on the AMD sata controller was very similar to a recent report about high rate transfers causing libata/linux to somehow loose connection with the host. Also the same error I saw people attribute to possible power or interrupt issues. But the errors are completely different on the mvsas controller.

> http://en.wikipedia.org/wiki/Dd_%28Unix%29#Recovery-
> oriented_variants_of_dd
> -Dave
> 
