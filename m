Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXJVFDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXJVFDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXJVFDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:03:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2813 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709AbXJVFDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:03:03 -0400
Date: Mon, 22 Oct 2007 13:02:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rik van Riel <riel@redhat.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
Message-ID: <20071022050243.GA16384@gondor.apana.org.au>
References: <471BF741.2020501@tiscali.nl> <20071021214209.1a7567d7@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021214209.1a7567d7@bree.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 01:42:09AM +0000, Rik van Riel wrote:
>
> BUG() will terminate the process that runs into it, so you can
> just remove the return alltogether.  If BUG() is hit, the return
> will never be reached.

This is true in general.  However, if someone builds the kernel
with CONFIG_BUG disabled then the return statement will make a
difference.  Of course, if you're brave enough to have CONFIG_BUG
off then you can deal with the fall-out :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
