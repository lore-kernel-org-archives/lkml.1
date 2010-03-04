Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0CDSnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:43:06 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:34410 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0CDSnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:43:01 -0500
MIME-Version: 1.0
Content-class: 
From: "Kalra Ashish-B00888" <B00888@freescale.com>
Message-ID: <292801cabbca$829e365e$2303d30a@fsl.freescale.net>
Subject: RE: Linux kernel - Libata bad block error handling to user mode  program
Date: Fri, 5 Mar 2010 00:11:01 +0530
Importance: normal
X-Priority: 3
Thread-Topic: Linux kernel - Libata bad block error handling to user mode  program
Thread-Index: Acq7yoKeZy5tcPu9TueFj9t2uW9HjA==
To: "Mark Lord" <kernel@teksavvy.com>, "foo saa" <foosaa@gmail.com>
Cc: "Greg Freemyer" <greg.freemyer@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Jens Axboe" <jens.axboe@oracle.com>, <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sent from my HTC

-----Original Message-----
From: Mark Lord <kernel@teksavvy.com>
Sent: 04 March 2010 11:20 PM
To: foo saa <foosaa@gmail.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>; Andrew Morton <akpm@linux-foundation.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; linux-ide@vger.kernel.org <linux-ide@vger.kernel.org>; Jens Axboe <jens.axboe@oracle.com>; linux-mm@kvack.org <linux-mm@kvack.org>
Subject: Re: Linux kernel - Libata bad block error handling to user mode  program

On 03/04/10 10:33, foo saa wrote:
..
> hdparm is good, but I don't want to use the internal ATA SECURE ERASE
> because I can never get the amount of bad sectors the drive had.
..

Oh.. but isn't that information in the S.M.A.R.T. data ??

You'll not find the bad sectors by writing -- a true WRITE nearly never
reports a media error.  Instead, the drive simply remaps to a good sector
on the fly and returns success.

Generally, only READs report media errors.

Cheers
--
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

