Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbXIUSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbXIUSLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXIUSLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:11:25 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:57591 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbXIUSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:11:25 -0400
Date: Fri, 21 Sep 2007 14:11:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] Text Edit Lock for 2.6.23-rc6-mm1
Message-ID: <20070921181122.GA30045@Krystal>
References: <20070918210601.028313546@polymtl.ca> <20070920161018.0b4e7ec3.akpm@linux-foundation.org> <20070921172950.GA22972@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070921172950.GA22972@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:11:05 up 53 days, 18:29,  4 users,  load average: 0.81, 0.66, 0.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Sep 20, 2007 at 04:10:18PM -0700, Andrew Morton wrote:
> > On Tue, 18 Sep 2007 17:06:01 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Here are the text edit lock patches ported to 2.6.23-rc6-mm1.
> > 
> > I think I'll duck these one more time.  There was a bit of followup
> > and for now I'd prefer to concentrate on obviously-safe stuff and
> > stabilisation of the current 2.6.24 queue.
> 
> As much as I'd love to see markers as soon as possible I have to agree.
> 
> I really hate how the first post of a handfull easy patches touching
> almost no core code has turned into this gigantic series.
> 
> Matthew, any chance you could resurrect a trivial, no-optimizations
> marker variant that has so little impact it could go into 2.6.24?
> 
> I'd really love to have the infrastructure there so we can add optimizations
> in parallel with actually adding the users to the tree.

Sure, I'll prepare that.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
