Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYIOHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYIOHzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 03:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYIOHyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:54:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYIOHyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:54:51 -0400
Date: Mon, 15 Sep 2008 09:54:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC][PATCH] x86: add memory clobber in switch_to()
Message-ID: <20080915075434.GB29585@elte.hu>
References: <20080914170353.GA15729@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914170353.GA15729@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> There are more places which have segment register reloads without 
> adding memory clobbers. Should we fix them up? Here's one of them:

yes, i think so.

> >From 5f135687f7730fbdd979b6fb408fd3ca08a0a678 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 14 Sep 2008 18:53:22 +0200
> Subject: [PATCH] x86: add memory clobber in switch_to()
> 
> Segment registers are reloaded, so we should add a memory clobber. The 
> generated assembly code is identical in my tests, but this doesn't 
> mean it is necessarily true for all configurations/compilers.

applied to tip/x86/core, thanks Vegard.

	Ingo
