Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYBYUvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYBYUvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbYBYUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:50:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbYBYUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:50:46 -0500
Date: Mon, 25 Feb 2008 21:50:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile problem in current x86.git
Message-ID: <20080225205035.GA3435@elte.hu>
References: <47C315CC.5020001@goop.org> <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com> <20080225204438.GA1213@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225204438.GA1213@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


> > Hm. This is x86#testing, no? I don't think there's any kmemcheck 
> > code whatsoever in other branches.

ah. that was x86.git#mm i think - a kmemcheck commit indeed prematurely 
got into that branch.

I've updated x86.git and it should all have the correct ordering now. 
(as of HEAD c9d2f5489cec70f814bf6)

Jeremy, you might want to start tracking x86.git#testing:

  http://people.redhat.com/mingo/x86.git/README

if you want to follow the latest & greatest x86.git code.

	Ingo
