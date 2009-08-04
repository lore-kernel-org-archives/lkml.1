Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbZHEA3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbZHEA3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbZHEA26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:58 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:37297 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932759AbZHEA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:29 -0400
X-Yahoo-Newman-Id: 221967.62741.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nlGcLDpy1UiuHf88/GsxWJVsMIDygVxGEmVtq7E9rOpQhR5u2vvodvehSv7J2vW16qGnwctTJS4ZE4/dczWF0ORm559W5yFqsVaTAPVq1T0eM82l+RurnzlYcEutncGIRUo2pptWy7wbuqLJpuj/tEw07Er5qlT6CJTVFYe1x/4=  ;
X-YMail-OSG: 6NFbw7wVM1lz4W0zUDtIKdjAwko2flnowB4JtS6v27y6yYPOi__F0_yIFdSXrh8ZSK4F4nYlKmyHVMAknRYm_3Hj8d_PXA0XDuI2FbzsTPKr_Lv0zQVzvMLw2cji6RXrLC0H4fUrgIiVyJHixyp4vGTKh22X1_6AjuKH4ZjKJXb4a6yHcH8QS6TOzt4bMnqmii.e8OjSN64.rUuerogwI3L1dlWPb5dMqz2GJEFtYaydEA5xymY7azu5Dbft6jgd62ofEkzH_W6KRJapTcazKl.9AsSq4EkMaQCZrlDPImybbByD
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: New MMC maintainer needed
Date: Mon, 3 Aug 2009 18:51:23 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl, ppisa@pikron.com,
       jarkko.lavinen@nokia.com, ben@fluff.org, saschasommer@freenet.de,
       avorontsov@ru.mvista.com, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090728222334.0c543c47@mjolnir.ossman.eu> <20090731122623.254fd0f1@mjolnir.ossman.eu>
In-Reply-To: <20090731122623.254fd0f1@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031851.24375.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, Pierre Ossman wrote:
> Restoring back the system state from MMC after a successful hibernation
> http://marc.info/?t=124818534700003&r=1&w=2
> 
> I don't agree with this approach. The point of the workqueue is so that
> the kernel can do things in parallel, so this patch is a step back. The
> problem is really with how the kernel doesn't properly cope with
> asynchronous disk scanning during bootup. The root_delay parameter was
> added for this for the "normal" case, but it seems more work is needed.

Doesn't handing of resumes needs more attention overall?

Example, root on eMMC (e.g. a 32-MByte non-removable chip) wouldn't
resume at all well the last time I checked ... mounted file systems
(not just root) made trouble.  Hardware that reliably reports card
insert/remove was rude in the same ways.

- Dave


