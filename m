Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYKEV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYKEV2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYKEV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:28:00 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54230 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbYKEV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:27:59 -0500
Date: Wed, 5 Nov 2008 22:27:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
To: Jeff Garzik <jeff@garzik.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: add test vectors for skein256/512/1024
Message-ID: <20081105212748.GA4990@Chamillionaire.breakpoint.cc>
References: <20081102161506.GA21940@havoc.gtf.org> <20081102201518.GA23620@Chamillionaire.breakpoint.cc> <490E5788.4080300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <490E5788.4080300@garzik.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik | 2008-11-02 20:44:40 [-0500]:

> Sebastian Andrzej Siewior wrote:
>> I grabed them from http://www.schneier.com/skein.html. The last test 
>> vector
>> (3) in every category is currently deactivated because it failed always.
>> It is unlikely that I made a type because I copy+pasted the tables + vim
>> magiced them. So maybe code may missbehave on requests lengths which are
>> not a multiple of 4 or the vectors can not be used due to some other
>> limitations that I've overseen.

Okay, that was a false positive :)
The "untouched" reference implementation outputs the same hash. The
additional information (tree, ...) is part of the third argument in
Skein_XXX_InitExt() which isn't used. So we can safely drop the third
test vector.

>
> 	Jeff

Sebastian
