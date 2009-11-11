Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbZKKXQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbZKKXQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZKKXP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:15:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:56612 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759508AbZKKXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:15:59 -0500
Date: Thu, 12 Nov 2009 07:15:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "ramaswamy.bm" <ramaswamy.bm@globaledgesoft.com>
Cc: kaber@trash.net, arrow.jianqing@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Subject: RE: port bound SAs : ip xfm state command  ?
Message-ID: <20091111231553.GC32544@gondor.apana.org.au>
References: <4AFA6C0D.2020101@globaledgesoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA6C0D.2020101@globaledgesoft.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 01:17:25PM +0530, ramaswamy.bm wrote:
> What is the command to write port based SA's using ip xfrm state.
>
> iam using below command for writing SA's : ip xfrm state add src 
> 192.168.1.20 dst 192.168.1.5 proto esp spi 0x354cb04b mode tunnel reqid 
> 16385 replay-window 32 auth sha1  
> 0xecf02a5cf6568556e1bdcd961c7ec3f92afd01cc enc aes  
> 0x5c0cfa9672ce67ba545b593076dfb278 sel src 0.0.0.0/0 dst 0.0.0.0/0  

Usually you don't want port-based SAs but port-based policies.
The syntax is described in "ip xfrm policy help".  Look for sport
and dport.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
