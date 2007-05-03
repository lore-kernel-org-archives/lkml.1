Return-Path: <linux-kernel-owner+w=401wt.eu-S1161504AbXECIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161504AbXECIGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161534AbXECIGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:06:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161504AbXECIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:06:51 -0400
Date: Thu, 3 May 2007 09:06:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503080638.GA23000@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502231104.GA26045@Krystal>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 07:11:04PM -0400, Mathieu Desnoyers wrote:
> My statement was probably not clear enough. The actual marker code is
> useful as-is without any further kernel patching required : SystemTAP is
> an example where they use external modules to load probes that can
> connect either to markers or through kprobes. LTTng, in its current state,
> has a mostly modular core that also uses the markers.

That just mean you have to load an enormous emount of exernal crap
that replaces the missing kernel functionality.  It's exactly the
situation we want to avoid.

