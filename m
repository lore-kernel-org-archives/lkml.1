Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbXJAK7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbXJAK7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXJAK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:59:27 -0400
Received: from mail.suse.de ([195.135.220.2]:36224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbXJAK70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:59:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] [13/50] x86: Fix and reenable CLFLUSH support in change_page_attr()
Date: Mon, 1 Oct 2007 12:59:20 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <20070921223211.BB50413DCD@wotan.suse.de> <E1IYxqR-0004uA-EA@flower>
In-Reply-To: <E1IYxqR-0004uA-EA@flower>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011259.20561.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 07:47:59 Oleg Verych wrote:
> * Sat, 22 Sep 2007 00:32:11 +0200 (CEST)
> []
> > -	flush_map(&l);
> > +	flush_map(&arg);
> 
>   +	flush_map(&arg.l);
> 
>   CC      arch/x86_64/mm/pageattr.o
> arch/x86_64/mm/pageattr.c: In function 'global_flush_tlb':
> arch/x86_64/mm/pageattr.c:274: warning: passing argument 1 of 'flush_map' from incompatible pointer type

That was already fixed; hmm perhaps that was an old patch.

-Andi
