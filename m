Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370Ab0AMOXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0AMOXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182Ab0AMOXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:23:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0AMOXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:23:02 -0500
Date: Wed, 13 Jan 2010 12:22:54 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
Message-ID: <20100113142254.GH2934@ghostprotocols.net>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
 <1263388569.4244.215.camel@laptop>
 <20100113133442.GB5036@nowhere>
 <20100113135205.GC5576@ghostprotocols.net>
 <1263391133.4244.226.camel@laptop>
 <20100113141344.GG2934@ghostprotocols.net>
 <1263392296.4244.228.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263392296.4244.228.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 13, 2010 at 03:18:16PM +0100, Peter Zijlstra escreveu:
> On Wed, 2010-01-13 at 12:13 -0200, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 13, 2010 at 02:58:53PM +0100, Peter Zijlstra escreveu:
> > > On Wed, 2010-01-13 at 11:52 -0200, Arnaldo Carvalho de Melo wrote:
> > > > Em Wed, Jan 13, 2010 at 02:34:45PM +0100, Frederic Weisbecker escreveu:
> > > > > At least it matches many patterns in perf :)
> > > > 
> > > > What an insane piece of... software! 8-) Whatever, if it makes Peter
> > > > happy we can keep it on tools/perf/util/include/linux/rbtree.h, just
> > > > after the:
> > > > 
> > > > #include "../../../../include/linux/rbtree.h"
> > > > 
> > > > ;-)
> > > > 
> > > > Just like we have list_del_range() in tools/perf/util/include/linux/list.h.
> > > 
> > > That's not the point, doing a for_each on the rb-trees as we have today
> > > is a O(n log(n)) operation, not something you should want to do often.
> > > 
> > > Adding a helper promotes the idea that its a sane thing to do, its not.
> > > 
> > > If you really need it, open coding it isn't hard, but the lack of helper
> > > does make you think and hopefully realize you're doing something funny.
> > 
> > We need it in several places in the perf tools, to present sorted results, to
> > dump the maps for debugging purposes, etc.
> > 
> > But I'll go and look at each one of them to see if there is any where it
> > is used in some stupid way.
> 
> Sure, but again, that's missing the point, adding that helper isn't a
> good thing. We have no 64bit division operators in Linux either, for the
> very same reason.

Ok, lets move forward, I'll remove the helper and resubmit.

- Arnaldo
