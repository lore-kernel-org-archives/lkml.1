Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbXLOGb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbXLOGb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXLOGbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:31:22 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2696 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbXLOGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:31:21 -0500
Date: Sat, 15 Dec 2007 14:31:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215063113.GA26443@gondor.apana.org.au>
References: <20071214132755.GA18309@gondor.apana.org.au> <20071214180246.GT17536@waste.org> <20071215041659.GB25324@gondor.apana.org.au> <20071215055218.GM19691@waste.org> <20071215060449.GA26199@gondor.apana.org.au> <20071215061200.GP19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215061200.GP19691@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 12:12:00AM -0600, Matt Mackall wrote:
>
> I tend to agree with this position, except when it comes to handling
> filesystems, where panic is often (but not always) the right thing to
> do.

Given the choice between crashing the machine or potentially giving
an attacker remote root access, I definitely prefer the former in
many instances in the network stack.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
