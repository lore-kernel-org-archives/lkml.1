Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZJLNAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZJLNAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZJLNAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:00:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44898 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZJLNAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:00:38 -0400
Date: Mon, 12 Oct 2009 14:59:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] thinkpad_acpi: fix build, HOTKEY_POLL is optional
Message-ID: <20091012125942.GA25464@elte.hu>
References: <20091009190654.741eeffd.sfr@canb.auug.org.au> <20091009161723.b68b91a7.randy.dunlap@oracle.com> <20091010000808.GA10637@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010000808.GA10637@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Fri, 09 Oct 2009, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix optional part of driver to be built optionally:
> 
> NAK!
> 
> This happens because of (linux-next) commit
> 7f6443f7238a0aa9014b11a0a31ab76825d75cdf 
> "thinkpad-acpi: Fix build on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL" by
> Ingo.
> 
> That commit is wrong, it must NOT be applied as explained in the 
> thread starting at http://lkml.org/lkml/2009/9/27/30.

Yep, that was wrong - it should be gone now.

	Ingo
