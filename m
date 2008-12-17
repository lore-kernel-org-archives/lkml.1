Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759258AbYLQF52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYLQF52 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYLQF5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:57:03 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37903 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754536AbYLQF5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:57:00 -0500
Date: Wed, 17 Dec 2008 16:56:55 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] crypto: salsa20 remove private wrappers around
	various operations
Message-ID: <20081217055655.GD14432@gondor.apana.org.au>
References: <1228785995.4353.11.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228785995.4353.11.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 05:26:35PM -0800, Harvey Harrison wrote:
> ROTATE -> rol32
> XOR was always used with the same destination, use ^=
> PLUS/PLUSONE use ++ or +=
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>


Patch applied.  Thanks Harvey!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
