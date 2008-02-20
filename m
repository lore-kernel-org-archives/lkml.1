Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBTR6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBTR6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYBTR6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:58:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49548 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752217AbYBTR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:58:30 -0500
Date: Thu, 21 Feb 2008 01:58:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <mbroz@redhat.com>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Message-ID: <20080220175819.GA28246@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au> <47BC67CE.9070407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC67CE.9070407@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 06:47:58PM +0100, Milan Broz wrote:
>
> I just tested one affected configuration and problem was in missing
> "chainiv.ko" module on ramdisk.

Ah OK.  We probably should merge chainiv into the blkcipher
module too since it's the default IV generator.  I'll take
care of it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
