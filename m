Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYAIHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYAIHUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYAIHUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:20:09 -0500
Received: from verein.lst.de ([213.95.11.210]:33996 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYAIHUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:20:08 -0500
Date: Wed, 9 Jan 2008 08:19:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       hch@lst.de, ak@suse.de, pq@iki.fi, jbeulich@novell.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Message-ID: <20080109071945.GB10695@lst.de>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie> <20080108190611.3b9c0760.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie> <20080108192951.a4dc394f.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:55:20AM +0000, Dave Airlie wrote:
> now because Linus said send him a patch to revert regressions rather than 
> just complain,

this is not a regression by any definition.  You were abusing exported
symbols for out of tree junk, so you'll lose.

