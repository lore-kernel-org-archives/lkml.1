Return-Path: <linux-kernel-owner+w=401wt.eu-S935016AbZAOXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016AbZAOXu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZAOXur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:50:47 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33898 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZAOXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:50:46 -0500
Date: Thu, 15 Jan 2009 23:50:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Grant Grundler <grundler@google.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
 sysfs
In-Reply-To: <1232061429.5966.87.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901152341500.15035@blonde.anvils>
References: <200901051952.58029.bzolnier@gmail.com> 
 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com> 
 <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru> 
 <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com>
  <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com> 
 <1232035561.5966.48.camel@localhost.localdomain> 
 <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com> 
 <1232046039.5966.54.camel@localhost.localdomain> 
 <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
 <1232061429.5966.87.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, James Bottomley wrote:
> 
> OK, so they could be calculated on the fly in the elevators, I suppose.
> But what would the value be?  Right now we use the nonrotational flag to
> basically not bother with plugging (no point if no seek penalty) on
> certain events where we'd previously have waited for other I/O to join.
> But that's really a seek penalty parameter rather than the idea of read
> or write costing (although the elevators usually track these dynamically
> anyway ... as part of the latency calculations but not explicitly).

... not bother with plugging (no point if no seek penalty) ...

I thought there was considerable advantage to plugging writes
(in case they turn out to be adjacent) on current and older
generations of non-rotational storage?

Hugh
