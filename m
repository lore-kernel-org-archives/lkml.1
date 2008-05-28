Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbYE1NRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbYE1NRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYE1NRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:17:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56888 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYE1NRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:17:05 -0400
Date: Wed, 28 May 2008 16:17:00 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <2874.1211980355@redhat.com>
Message-ID: <Pine.LNX.4.64.0805281614250.26675@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
 <2874.1211980355@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, David Howells wrote:
> Works for SLAB and SLUB.  SLOB breaks well before getting to anything these
> patches affect.
> 
> Acked-by: David Howells <dhowells@redhat.com>

Thanks for testing! Where do I send these patches though? There's no entry 
for no-MMU in MAINTAINERS. I guess I could just send them to Andrew...

		Pekka
