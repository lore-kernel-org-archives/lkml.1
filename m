Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZJBR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZJBR5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZJBR5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:57:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZJBR5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:57:47 -0400
Date: Fri, 2 Oct 2009 19:57:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Trevor Hemsley <trevor.hemsley@ntlworld.com>, linux-kernel@vger.kernel.org
Subject: Re: Temperature above threshold loop with 2.6.31.1
Message-ID: <20091002175745.GB14860@elte.hu>
References: <20091002134430.SOPU22934.aamtaout04-winn.ispmail.ntl.com@trevor2.dsl.pipex.com> <200910021703.31679.elendil@planet.nl> <200910021938.09486.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910021938.09486.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Friday 02 October 2009, Frans Pop wrote:
> > Trevor Hemsley wrote:
> > > 1,666 notifications a second seems a little on the 'too frequent' side
> > > of things to me :-)
> >
> > Looks like this may already be fixed in mainline by the following
> > commit: commit b417c9fd8690637f0c91479435ab3e2bf450c038
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Tue Sep 22 15:50:24 2009 +0200
> >     x86: mce: Fix thermal throttling message storm
> >
> > Can you confirm that please, either by compiling current git or by
> > applying that commit on top of 2.6.31.1?
> 
> If you want to apply it to .31.1 you'll also need this commit:
> commit 3967684006f30c253bc6d4a6604d1bad4a7fc672
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Sep 22 15:50:24 2009 +0200
>     x86: mce: Clean up thermal throttling state tracking code

Yes. The way to test this is to do this on top of a .31.1 tree:

 git cherry-pick 3967684006f30c253bc6d4a6604d1bad4a7fc672
 git cherry-pick b417c9fd8690637f0c91479435ab3e2bf450c038

	Ingo
