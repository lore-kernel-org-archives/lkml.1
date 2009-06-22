Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFVNtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFVNtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZFVNtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:49:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZFVNtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:49:25 -0400
Date: Mon, 22 Jun 2009 15:50:14 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] profile: Suppress warning about large allocations when
 profile=1 is specified
Message-ID: <20090622135014.GA7776@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
 <20090616223649.719ea378.akpm@linux-foundation.org>
 <20090617111800.GA15261@elte.hu>
 <20090617113120.GA5061@elte.hu>
 <20090617113534.GA21276@elte.hu>
 <20090617121913.GC28529@csn.ul.ie>
 <20090620100932.GA5863@fancy-poultry.org>
 <20090620195000.GC10878@csn.ul.ie>
 <20090620214835.GA6528@fancy-poultry.org>
 <20090622113104.GD3981@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622113104.GD3981@csn.ul.ie>
Organization: private site
X-PGP-Key-Id: 0x3FAF957D
User-Agent: Mutt/1.5.20+20090615 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18f/VFcNjcuX+/h0DYDGYlBQozRnPgdnkHdOxq
 hxnEuGidTxOPZTzo2Wm8GZCP+i2rCoBr4LjNbEZiNsPL1qpF7o
 cQH3fJVyEug4utwWinY6AkwfT8Hto6v
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.06.2009, Mel Gorman wrote: 

> I have no idea why the stack trace is so badly managed but the problem appears
> to be in DCCP so can you try the patch below please? It applies on top of the
> profile=1 patch fix. If it works for you, I'll split out the patch properly
> into three separate patches and repost.

This patch, on top of your "profile=1" fix and applied to -git17, 
does indeed fix the problem for me.

Thanks,
Heinz.

