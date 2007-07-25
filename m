Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbXGYLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbXGYLHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbXGYLHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:07:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:13200 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529AbXGYLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lkfqd7F5TwEVxy2q4wsdXZYOM98g3iKulnvw7iJd1vObM9c8UNPbLTK5f5UJp6HokGkoEY1l7gSrvXqVSasbnh8OrAnaJZXm+EkUFIumY2mWq1660jPGeou2KK9R6UnGIiQzR/kUArv6NcYTgTxGeduoYYp7ytmvCy8n/nskeSA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] bsg: Fix build for CONFIG_BLOCK=n
Date: Wed, 25 Jul 2007 13:04:56 +0200
User-Agent: KMail/1.9.6
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070725072354.GA18706@linux-sh.org>
In-Reply-To: <20070725072354.GA18706@linux-sh.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707251304.56505.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 25 July 2007, Paul Mundt wrote:
> BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to
> be enabled when CONFIG_BLOCK=n. This leads to many screenlengths of
> errors, starting with a parse error on the request_queue_t definition.
> Obviously this wasn't intended for CONFIG_BLOCK=n usage, so just move the
> option back in to the block.
> 
> Caught with a randconfig on sh.

also pointed out in my bsg review from a week ago ;)

http://lkml.org/lkml/2007/7/17/487

> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Thanks for fixing this up.

Bart
