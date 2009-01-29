Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZA2Ngw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZA2Ngw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZA2Ngn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:36:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZA2Ngn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:36:43 -0500
Date: Thu, 29 Jan 2009 14:36:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: trampoline_64.S - use predefined constants
	with simplification
Message-ID: <20090129133636.GF24391@elte.hu>
References: <20090128202125.GA32555@localhost> <1233179577.19086.1297291037@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233179577.19086.1297291037@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Wed, 28 Jan 2009 23:21:25 +0300, "Cyrill Gorcunov"
> <gorcunov@gmail.com> said:
> > Impact: cleanup
> > 
> > We may use macros from processor-flags.h instead
> > of hardcoding bits. Actually it's not direct mapping
> > of old instructions with new ones -- BTS does change
> > CF flag while MOV does not. But i didn't find any
> > dependency on CF in this code.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> >
> > Please review
> 
> Looks good.
> 
> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/asm, thanks guys!

	Ingo
