Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273Ab0AMNwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0AMNwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133Ab0AMNwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:52:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0AMNwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:52:12 -0500
Date: Wed, 13 Jan 2010 11:52:05 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
Message-ID: <20100113135205.GC5576@ghostprotocols.net>
References: <1263387673-15231-1-git-send-email-acme@infradead.org> <1263388569.4244.215.camel@laptop> <20100113133442.GB5036@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113133442.GB5036@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 13, 2010 at 02:34:45PM +0100, Frederic Weisbecker escreveu:
> On Wed, Jan 13, 2010 at 02:16:09PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-13 at 11:01 -0200, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > Similar to list_for_each_entry, helps reducing boilerplate in many
> > > places and makes rbtrees closer to list.h macros.
> > > 
> > > First conversion will be in the tools/perf.
> > 
> > I'm still not sure you really want to do this, it might give people the
> > impression its a sane thing to do ;-)
> 
> At least it matches many patterns in perf :)

What an insane piece of... software! 8-) Whatever, if it makes Peter
happy we can keep it on tools/perf/util/include/linux/rbtree.h, just
after the:

#include "../../../../include/linux/rbtree.h"

;-)

Just like we have list_del_range() in tools/perf/util/include/linux/list.h.

- Arnaldo
