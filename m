Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbYHFLNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbYHFLNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbYHFLNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:13:12 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:48472 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757125AbYHFLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:13:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c7iGettrF6ft7F9TEkpM9DQELd1QNyO0Q5eY3lRsAYhyvEVXDm3107NgDusvqeTw6k9U7RY984aeryuNlOJBKwzN50/s8NFvfzAAwyOjyQbIgGGknIBktoi4HdpWjGRp+SJkjyd/eirV7PooAsXmXo0z2rkL4atu/ff8/qusrEA=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for August 5 (MTD build error)
Date: Wed, 6 Aug 2008 04:13:08 -0700
User-Agent: KMail/1.9.9
Cc: dwmw2@infradead.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20080805175914.7649537f.sfr@canb.auug.org.au> <20080805175518.9fc09b92.randy.dunlap@oracle.com> <200808060320.20064.david-b@pacbell.net>
In-Reply-To: <200808060320.20064.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060413.08723.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, David Brownell wrote:
> On Tuesday 05 August 2008, Randy Dunlap wrote:
> > 
> > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c: In function 'add_dataflash_otp':
> > linux-next-20080805/drivers/mtd/devices/mtd_dataflash.c:670: error: too many arguments to function 'otp_setup'
> 
> Bad merge somewhere? 

Whoops, sorry ... I see what was going on.  My bad.

--- g26.orig/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:12:45.000000000 -0700
+++ g26/drivers/mtd/devices/mtd_dataflash.c	2008-08-06 04:11:55.000000000 -0700
@@ -616,7 +616,7 @@ static char *otp_setup(struct mtd_info *
 
 #else
 
-static char *otp_setup(struct mtd_info *device)
+static char *otp_setup(struct mtd_info *device, char revision)
 {
 	return " (OTP)";
 }
