Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbZAOI60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbZAOI60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZAOI5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:57:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbZAOI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:57:41 -0500
Date: Thu, 15 Jan 2009 09:57:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
Message-ID: <20090115085728.GA28607@elte.hu>
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com> <496F0796.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F0796.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> "H. Peter Anvin" <hpa@zytor.com> 14.01.09 20:39 >>>
> >Jan Beulich wrote:
> >> Additionally remove the dependency of X86_PAE on !HIGHMEM4G - at least
> >> I can't understand why that dependency existed.
> >
> >At least originally, the meaning of the x86 highmem entries were:
> >
> >	No highmem	- No highmem, no PAE
> >	HIGHMEM4G	- Highmem, no PAE
> >	HIGHMEM64G	- Highmem, PAE
> >
> >So X86_PAE and HIGHMEM4G is a bit of a contradiction.  I haven't looked 
> >at the logic in detail, or remember offhand if there have been any 
> >weakening of the definitions above; e.g. someone could have implemented 
> >a way to do PAE without highmem, to get access to the NX bits.
> 
> Exactly - .23 made PAE an independently selectable option (in 
> particular, the no-highmem+PAE combination is now valid), but I can't 
> see why it added the !HIGHMEM4G dependency.

There's no deep reason, it just has never really been tested that way. I 
think we should try it.

	Ingo
