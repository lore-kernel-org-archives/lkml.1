Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbXA2VoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbXA2VoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXA2VoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:44:11 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:48408 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752574AbXA2VoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:44:09 -0500
Date: Mon, 29 Jan 2007 13:44:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab.c ifdef reduction breaks build
In-Reply-To: <20070129125630.dfba64a4.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701291343180.548@schroedinger.engr.sgi.com>
References: <20070129200517.GA6229@ccure.user-mode-linux.org>
 <Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701291240020.401@schroedinger.engr.sgi.com>
 <20070129125630.dfba64a4.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andrew Morton wrote:

> On Mon, 29 Jan 2007 12:41:33 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > +#ifdef CONFIG_ZONE_DMA
> >  		if (CONFIG_ZONE_DMA_FLAG)
> 
> We don't need the `if (CONFIG_ZONE_DMA_FLAG)' any more, do we?

Correct.

