Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbXCULm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbXCULm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXCULm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:42:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45527 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXCULmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:42:55 -0400
Date: Wed, 21 Mar 2007 13:42:53 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <Pine.LNX.4.64.0703201140350.8561@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0703211342001.13029@sbz-30.cs.Helsinki.FI>
References: <20070319141038.212d4ac9.akpm@linux-foundation.org> 
 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi> 
 <20070319144100.8a87f288.akpm@linux-foundation.org>
 <84144f020703200006q5fbd7835y216426e77e48cc71@mail.gmail.com>
 <Pine.LNX.4.64.0703201140350.8561@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Christoph Lameter wrote:
> CONFIG_DEBUG_SLAB is there in order to handle these nasty and hard to 
> debug problems. Usually non-slab pages are not passed to kmem_cache_free.

Yeah, it's probably not a big deal for kmem_cache_free() but if we make 
the BUG_ON CONFIG_DEBUG_SLAB, kfree() loses it as well.

		Pekka
