Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYAIUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYAIUlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYAIUlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:41:11 -0500
Received: from c60.cesmail.net ([216.154.195.49]:41073 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYAIUlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:41:10 -0500
Subject: Re: Replacement for page fault notifiers?
From: Pavel Roskin <proski@gnu.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: benh@kernel.crashing.org, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <20080109202644.GA5514@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
	 <1199910256.11485.14.camel@dv>  <20080109202644.GA5514@infradead.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 15:41:08 -0500
Message-Id: <1199911268.11485.18.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 20:26 +0000, Christoph Hellwig wrote:
> On Wed, Jan 09, 2008 at 03:24:16PM -0500, Pavel Roskin wrote:
> > I just assumed (wrongly, as it seems) that the API change didn't remove
> > any useful functionality.
> 
> No, this was exactly the correct assumption.  Out of tree modules simply
> don't count.
> 
> > The problem is that mmiotrace only makes sense in combination with
> > non-free drivers, and I'm not sure it would be welcome in the kernel
> > even if you say so.
> 
> It can trace every driver in theory although it's of course not
> really interesting for free drivers.  But it's not actually
> functionality used by the drivers but functionlity to trace the drivers
> so it's quite different anyway.

OK, that's reassuring.  Maybe it could be used for profiling or to find
bugs that are not obvious otherwise.

-- 
Regards,
Pavel Roskin
