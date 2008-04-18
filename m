Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYDREV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYDREV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYDREVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:21:21 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:28335 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYDREVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:21:20 -0400
Date: Fri, 18 Apr 2008 00:21:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-ID: <20080418042119.GB16276@phobos.i.cabal.ca>
References: <20080410032354.90CB1DDF0F@ozlabs.org> <20080413171953.bde5e9ac.akpm@linux-foundation.org> <1208133506.6958.82.camel@pasglop> <20080413191338.9776ebd0.akpm@linux-foundation.org> <1208491086.6958.381.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208491086.6958.381.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:58:06PM +1000, Benjamin Herrenschmidt wrote:
> Well, looking there, I saw we already used weak symbols for that so what
> about the patch below ? If you're ok, I'll re-send with appropriate sob
> & adapted powerpc part.
> 

This is definitely the cleanest way to do this from my pov. Although I'm
slightly concerned about the proliferation of weak symbols, I'm much
more concerned with adding more include-order-dependent arch overrides. :)

speaking with the parisc dunce-cap on,
	Kyle
