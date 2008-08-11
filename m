Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYHKQrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYHKQrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYHKQrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:47:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbYHKQrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:47:00 -0400
Date: Mon, 11 Aug 2008 18:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Horman <horms@verge.net.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@kernel.org>,
       Mark McLoughlin <markmc@redhat.com>, xen-devel@lists.xensource.com,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: work around gcc 3.4.x bug
Message-ID: <20080811164423.GF4524@elte.hu>
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org> <20080808080155.GA1992@cs181140183.pp.htv.fi> <489C6485.7050009@goop.org> <20080808161331.GF14495@cs181140183.pp.htv.fi> <489C89FA.5000301@goop.org> <20080808183711.GA14495@cs181140183.pp.htv.fi> <489CB08F.9030902@goop.org> <20080809062937.GA5424@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809062937.GA5424@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Horman <horms@verge.net.au> wrote:

> On Fri, Aug 08, 2008 at 01:46:07PM -0700, Jeremy Fitzhardinge wrote:
> > gcc-3.4.x crashes when compiling pgd_prepopulate_pmd() when
> > PREALLOCATED_PMDS == 0 and CONFIG_DEBUG_INFO is enabled.  This seems
> > to avoid the problem.
> >
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Adrian Bunk <bunk@kernel.org>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Hi Jeremy,
> 
> This does solve the problem I was seeing on on 3.4.5.
> 
> Acked-by: Simon Horman <horms@verge.net.au>

applied to tip/x86/urgent - thanks for tracking this down.

	Ingo
