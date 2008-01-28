Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYA1ONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYA1ONz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbYA1ONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:13:48 -0500
Received: from namei.org ([69.55.235.186]:52571 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757649AbYA1ONr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:13:47 -0500
Date: Tue, 29 Jan 2008 01:13:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [AUDIT]: Increase skb->truesize in audit_expand
In-Reply-To: <20080128111018.GA6442@gondor.apana.org.au>
Message-ID: <Xine.LNX.4.64.0801290112300.12951@us.intercode.com.au>
References: <20080128111018.GA6442@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Herbert Xu wrote:

> Hi:
> 
> [AUDIT]: Increase skb->truesize in audit_expand
> 
> The recent UDP patch exposed this bug in the audit code.  It
> was calling pskb_expand_head without increasing skb->truesize.
> The caller of pskb_expand_head needs to do so because that function
> is designed to be called in places where truesize is already fixed
> and therefore it doesn't update its value.
> 
> Because the audit system is using it in a place where the truesize
> has not yet been fixed, it needs to update its value manually.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: James Morris <jmorris@namei.org>


(Candidate for stable ?)


- James
-- 
James Morris <jmorris@namei.org>
