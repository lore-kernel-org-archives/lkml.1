Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYACRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYACRRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYACRRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:17:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYACRRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:17:18 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH x86] [6/16] Add a new arch_early_alloc() interface for x86-64
Date: Thu, 3 Jan 2008 18:17:13 +0100
User-Agent: KMail/1.9.6
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <20080103154220.0CCD814DDB@wotan.suse.de> <20080103172235.58c069c9.dada1@cosmosbay.com>
In-Reply-To: <20080103172235.58c069c9.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031817.13916.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +		/* Risk filling the DMA zone */
> > +		p = find_e820_area(EARLY_ALLOC_START, -1UL, size);
> 
> Hum... Are you sure of this EARLY_ALLOC_START here ?


Good catch. I'll repost with that fixed.

-Andi

