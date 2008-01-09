Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYAIU1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYAIU1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYAIU0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:26:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54170 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYAIU0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:26:49 -0500
Date: Wed, 9 Jan 2008 20:26:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: benh@kernel.crashing.org, Christoph Hellwig <hch@infradead.org>,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080109202644.GA5514@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi> <20080108203235.GA772@infradead.org> <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com> <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv> <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop> <1199910256.11485.14.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199910256.11485.14.camel@dv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:24:16PM -0500, Pavel Roskin wrote:
> I just assumed (wrongly, as it seems) that the API change didn't remove
> any useful functionality.

No, this was exactly the correct assumption.  Out of tree modules simply
don't count.

> The problem is that mmiotrace only makes sense in combination with
> non-free drivers, and I'm not sure it would be welcome in the kernel
> even if you say so.

It can trace every driver in theory although it's of course not
really interesting for free drivers.  But it's not actually
functionality used by the drivers but functionlity to trace the drivers
so it's quite different anyway.

> Exactly.  In MadWifi, they are inlined on i386 and x86_64, and I cannot
> ask every user with an unsupported card to get a Mac.

Maybe it's time to do some simple xoring in the ioremap return value
to force them not to do such stupid things..

