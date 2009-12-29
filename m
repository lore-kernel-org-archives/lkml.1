Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZL2VXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZL2VXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZL2VXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:23:18 -0500
Received: from mail.perches.com ([173.55.12.10]:1448 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZL2VXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:23:18 -0500
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, James.Bottomley@suse.de,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0912292103180.4001@ask.diku.dk>
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
	 <200912292102.43373.eike-kernel@sf-tec.de>
	 <Pine.LNX.4.64.0912292103180.4001@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 13:23:16 -0800
Message-ID: <1262121796.1888.190.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 21:04 +0100, Julia Lawall wrote:
> On Tue, 29 Dec 2009, Rolf Eike Beer wrote:
> > Julia Lawall wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > > In each case, the destination of the allocation has type struct **, so the
> > > elements of the array should have pointer type, not structure type.
> > Maybe they should even by kcalloc'ed?
> I thought about that, but in response to another patch someone seemed to 
> think kcalloc was not very useful.  But I can certainly change it in this 
> case.

I think kcalloc is useful and should be used when the
allocated array of elements needs to be zeroed.

It appears the uses in 1/5 and 3/5 don't need it but
maybe patch 2/5 and 4/5 should use kcalloc.


