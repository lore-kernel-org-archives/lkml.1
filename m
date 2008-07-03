Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYGCLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYGCLz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYGCLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:55:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35436 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191AbYGCLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:09 -0400
Date: Thu, 3 Jul 2008 19:05:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Katz <katzj@redhat.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] Make loading padlock modules quieter when hardware isn't available
Message-ID: <20080703110502.GA28699@gondor.apana.org.au>
References: <1214948495-19849-1-git-send-email-katzj@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214948495-19849-1-git-send-email-katzj@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 05:41:35PM -0400, Jeremy Katz wrote:
> When loading aes or sha256 via the module aliases, the padlock modules
> also try to get loaded.  Make the error message for them not being
> present only be a NOTICE rather than an ERROR so that use of 'quiet'
> will suppress the messages
> 
> Signed-off-by: Jeremy Katz <katzj@redhat.com>

Patch applied.  Thanks Jeremy!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
