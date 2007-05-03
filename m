Return-Path: <linux-kernel-owner+w=401wt.eu-S1162174AbXECRZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162174AbXECRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162191AbXECRZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:25:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39844 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162174AbXECRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:25:55 -0400
Date: Thu, 3 May 2007 18:25:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503172546.GA13392@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070502162135.f949e371.akpm@linux-foundation.org> <20070503150415.GC26864@Krystal> <20070503151201.GA27281@infradead.org> <20070503171646.GA506@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503171646.GA506@Krystal>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 01:16:46PM -0400, Mathieu Desnoyers wrote:
> > kprobes does this kind of synchronization internally, so the marker
> > wrapper should probabl aswell.
> > 
> 
> The problem appears on heavily loaded systems. Doing 50
> synchronize_sched() calls in a row can take up to a few seconds on a
> 4-way machine. This is why I prefer to do it in the module to which
> the callbacks belong.

We recently had a discussion on batch unreistration interface for
kprobes.  I'm not very happy with having so different interfaces for
different kind of probe registrations.

