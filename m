Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYAIUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYAIUXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYAIUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:23:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50736 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYAIUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:22:59 -0500
Date: Wed, 9 Jan 2008 20:22:54 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080109202254.GA5279@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi> <20080108203235.GA772@infradead.org> <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com> <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv> <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199908703.6734.133.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 06:58:23AM +1100, Benjamin Herrenschmidt wrote:
> It's a sane thing to do, Christoph, I don't think it's a unreasonable
> request to put the hooks back in.

As said a few times before there's simply no way we're going to put
exactly that crap back.  For one the patch removed a whole lot of
crud from the kprobes code that simply isn't going to come back just
because there are some pagefault notifiers.  Second the page fault
notifiers were horribly implemented and quite inefficient.  And third
we're not going to put something in just for out of tree code.

Please submit the mmiotrace for 2.6.25 and we'll find some way to make
it work.

