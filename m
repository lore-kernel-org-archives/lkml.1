Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYJAHHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYJAHHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYJAHHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:07:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbYJAHHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:07:05 -0400
Date: Wed, 1 Oct 2008 09:06:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 0/4] traps: x86: more unification
Message-ID: <20081001070656.GB651@elte.hu>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hi Ingo,
> 
> Here are some more unification patches for traps_xx.c. They
> are against the current x86/traps branch in the tip tree and
> work fine for my miniconfigs.

applied to tip/x86/traps, thanks Alexander!

> The branch does not at the moment compile a defconfig kernel, due to a 
> missing PCI_DEVICE_ID_AMD_10H_NB_MISC define, however.

hm, commit 021f8b7 was missing, cf16970 got detached from that commit. I 
fixed it all up in tip/x86/traps.

	Ingo
