Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYAENYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYAENYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYAENYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:24:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:39595 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYAENYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TbOOgR0b/luRacAyxr/qKpKHTzqggdn97cCtWw92nA6ySL6NEJlCS2a1/Z35nY+T6owTuyUhI4vN1jE6+czlyz/iP6ppNkFA28Sdggx9yB/kWg17aWjqz/brINFXhylOAAHRN9/ruMGbr6NmHYHrYoX/8dzywC2Xsmpy1MrrGxQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ide: delete filenames/versions from comments
Date: Sat, 5 Jan 2008 14:15:06 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <fa.CAem1qRl3AG/KJjVoPZU/Cn8U1g@ifi.uio.no> <477C2EE8.50301@shaw.ca>
In-Reply-To: <477C2EE8.50301@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801051415.06557.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 03 January 2008, Robert Hancock wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Delete filenames/versions from comments.
> > 
> > I'm leaving decisions about adding DRV_VERSION defines and MODULE_VERSION()-s
> > to maintainers of the respective drivers.
> > 
> > While at it:
> > 
> > * Remove unused VERSION define from ide.c.
> > 
> > * Remove unused/stale DRV_VERSION define from au1xxx-ide.c.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> How about getting rid of this stupid thing in drivers/ide/ide.c:
> 
> #define	REVISION	"Revision: 7.00alpha2"
> 
> which is used in:
> 
> printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
> 
> It's been 7.00alpha2 for god knows how long, so clearly this version 
> number is not useful..

Yep, care to make a patch removing it?

Thanks,
Bart
