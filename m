Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXJRVss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXJRVss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbXJRVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:48:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:55994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbXJRVsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:48:40 -0400
Date: Thu, 18 Oct 2007 23:48:37 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernhard Walle <bwalle@suse.de>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, ak@suse.de, vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
Message-ID: <20071018214836.GA3459@bingen.suse.de>
References: <20071018111535.356215664@strauss.suse.de> <20071018111535.883533731@strauss.suse.de> <20071018142642.5b3f6ba4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018142642.5b3f6ba4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +extern char _text[], _end[], _etext[], _edata[], _bss[];
> 
> These should be in a header file.

Normally the "no externs in .c" rule doesn't apply to assembler or linker 
script defined labels. That's because the point of the header file is to 
type check them, but there is nothing to type check here.

-Andi
