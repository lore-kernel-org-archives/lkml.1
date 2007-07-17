Return-Path: <linux-kernel-owner+w=401wt.eu-S936278AbXGQW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936278AbXGQW61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbXGQW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:58:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757894AbXGQW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:58:17 -0400
Date: Tue, 17 Jul 2007 15:57:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <200707180045.03352.bzolnier@gmail.com>
Message-ID: <alpine.LFD.0.999.0707171550010.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com>
 <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
 <200707180045.03352.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Got back to this after thinking about it some more .. ]

On Wed, 18 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> For now it should be sufficient to revert ide.c chunks of
> 
> commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3

Come to think about this, doesn't the old code trigger this problem too, 
if you use CDROMEJECT or CDROMCLOSETRAY on a IDE disk (as opposed to an 
IDE CD-ROM)?

But I'll revert that part of it for now, and at least this issue won't be 
anything new. In the meantime, BSG has also gotten some other fixes, most 
notably about them the fact that it's not marked default any more, and 
properly warning about its EXPERIMENTAL status..

		Linus
