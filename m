Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbYBGXUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbYBGXUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbYBGXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:20:19 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:37806 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYBGXUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:20:17 -0500
Date: Thu, 7 Feb 2008 18:20:15 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: parisc compile error
Message-ID: <20080207232015.GA11653@phobos.i.cabal.ca>
References: <20080207231232.GF7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207231232.GF7198@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 01:12:32AM +0200, Adrian Bunk wrote:
> Commit 9e2779fa281cfda13ac060753d674bbcaa23367e broke parisc:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/parisc/kernel/asm-offsets.s
> In file included from include/asm/pgtable.h:13,
>                  from arch/parisc/kernel/asm-offsets.c:36:
> include/linux/mm.h: In function 'is_vmalloc_addr':
> include/linux/mm.h:243: error: 'VMALLOC_START' undeclared (first use in this function)
> include/linux/mm.h:243: error: (Each undeclared identifier is reported only once
> include/linux/mm.h:243: error: for each function it appears in.)
> include/linux/mm.h:243: error: 'VMALLOC_END' undeclared (first use in this function)
> make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
> 

yes, it's in my batch of fixes.

thanks for the reminder.

cheers, kyle
