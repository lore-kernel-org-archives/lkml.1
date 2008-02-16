Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYBPTjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYBPTjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYBPTjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:39:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbYBPTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:39:39 -0500
Date: Sat, 16 Feb 2008 11:39:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: include/linux/pcounter.h
Message-ID: <20080216113909.54c0d3df@laptopd505.fenrus.org>
In-Reply-To: <20080216112618.ec450f9b.akpm@linux-foundation.org>
References: <20080204014402.1c55d3fe.akpm@linux-foundation.org>
	<20080215193711.2e3d41f3.akpm@linux-foundation.org>
	<47B6B5E1.90705@cosmosbay.com>
	<20080216025051.751b4a86.akpm@linux-foundation.org>
	<47B6D12A.3090401@cosmosbay.com>
	<20080216112618.ec450f9b.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 11:26:18 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > indirect functions calls are everywhere in kernel, network, fs,
> > everywhere.
> 
> That doesn't make them fast.

just to emphasize this: an indirect function call is at least as expensive as an atomic operation on 
x86 cpus.... (if not more)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
