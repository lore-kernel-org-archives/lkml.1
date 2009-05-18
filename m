Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZERP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZERP4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZERP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:56:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54670 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbZERP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:56:36 -0400
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <1242661288.1572.82.camel@Joe-Laptop.home>
References: <cover.1242609803.git.joe@perches.com>
	 <200905181612.43632.bzolnier@gmail.com>
	 <1242661288.1572.82.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Mon, 18 May 2009 15:56:37 +0000
Message-Id: <1242662198.6347.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 08:41 -0700, Joe Perches wrote:
> On Mon, 2009-05-18 at 16:12 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 18 May 2009 04:21:08 Joe Perches wrote:
> > > Mostly mechanical conversion of printk's
> > Hmm.. less mechanical conversion using also dev_*() macros where suitable
> > would be much better...
> > How's about fixing pr_devel() which currently doesn't seem to be used
> > by anything inside kernel to not depend on DEBUG in separate pre-patch
> > and then using it instead of pr_debug()?
> 
> How about deferring the "printk(KERN_DEBUG" to something else
> and doing the mechanical conversion to core as a first pass,
> followed by core pr_<foo> to dev_<foo> where appropriate
> as a second pass?

What exactly is the point of a mechanical conversion from
printk(KERN_ ...) to pr_...?

I can see the value of the pr_ macros from new code in that the
temptation to put a comma after KERN_.. for some people is irresistible
so it's an interface that's very easy to misuse, but given that we have
correct uses, why convert them?

James


