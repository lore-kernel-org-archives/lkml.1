Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYG3PZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYG3PZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYG3PZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:25:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYG3PZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:25:13 -0400
Subject: Re: [RFT: 2.6 patch] fix text console corruptions
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Tim Bird <tim.bird@am.sony.com>, Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, Grant Coady <grant_lkml@dodo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080730140655.GC19966@cs181140183.pp.htv.fi>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl>
	 <200807291815.13907.alistair@devzero.co.uk>
	 <BAY103-W38794846AA924235B38E47B2820@phx.gbl>
	 <488FAFE3.4040001@am.sony.com>
	 <20080730140655.GC19966@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 16:24:49 +0100
Message-Id: <1217431489.27925.258.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 17:06 +0300, Adrian Bunk wrote:
> On Tue, Jul 29, 2008 at 05:03:47PM -0700, Tim Bird wrote:
> > Marco Berizzi wrote:
> > > alistair@devzero.co.uk wrote:
> > > 
> > >> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?
> > > 
> > > yes console_translation is set to yes. It cannot be changed if embedded is not
> > > set.
> > 
> > If console_translation is set to yes, the behavior should be unchanged from
> > 2.6.26.
> >...
> 
> Your commit contains a change that breaks due to | having a higher 
> precedence than ?: in C.

Oh, I think that's probably my fault then; sorry.

-- 
dwmw2

