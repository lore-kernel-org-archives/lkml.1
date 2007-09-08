Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXIHMLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXIHMLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 08:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXIHML3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 08:11:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbXIHML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 08:11:28 -0400
Date: Sat, 8 Sep 2007 13:11:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] Linux Kernel Markers - Port SPU to markers
Message-ID: <20070908121123.GC8478@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070906200733.194442762@polymtl.ca> <20070906200827.452767571@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200827.452767571@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:07:39PM -0400, Mathieu Desnoyers wrote:
> Andrew, any chance to get this into -mm ASAP so we can have it in
> 2.6.24?
> 
> Just in case anyone wonders what this is usefulfor I've ported my
> hacking spu tracing code to it, and if markers get in I'd push a cleaned
> up version of this in the tree of the benefit of everyone trying to
> follow what's going on in the spufs code.  Similarly I'd like to port
> the xfs tracing code over to it which is very helpful in trying to
> debug filesystem issues.
> 
> Note that in this patch the actual logging code is rather nasty
> hand-crafted code lifted from the tcp probe in tree which would benefit
> of going away in favour of more general tracing code aswell.
> 
> Changelog:
> - Porting to 2.6.23-rc4-mm1 gave a reject (a trace point location disappeared)
>   from spufs_ps_nopfn() : spufs_ps_nopfn__sleep and spufs_ps_nopfn__wake.

The subject is rather confusing.  What I ported to markers is the spu _tracing_
support.  And given it's never been public before adding the port part to the
commit doesn't make much sense.

Nevermind, I have updated version of this and would prefer to submit it myself
through the spufs maintainer once markers make mainline (hopefully soon!)

I'll also need more cleanups like adding a config option for it.

