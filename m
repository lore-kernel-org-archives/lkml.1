Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbXLaWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbXLaWb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXLaWbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:31:48 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1073 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbXLaWbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:31:47 -0500
Date: Tue, 1 Jan 2008 09:31:10 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH -mm] crypto: scatterwalk.h needs sched.h
Message-ID: <20071231223110.GA15921@gondor.apana.org.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231100539.0a782c40.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231100539.0a782c40.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 10:05:39AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_PREEMPT_NONE=y, scatterwalk.h still uses cond_resched()
> so it needs to include sched.h:

Thanks.  This is already in cryptodev-2.6.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
