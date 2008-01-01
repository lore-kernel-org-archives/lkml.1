Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYAAPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYAAPGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYAAPGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:06:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYAAPGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:06:36 -0500
Date: Tue, 1 Jan 2008 16:06:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101150607.GC4434@elte.hu>
References: <20080101134809.GK2360@does.not.exist> <20080101142623.GA3592@elte.hu> <20080101143022.664e8894@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101143022.664e8894@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> [...] As the alternative is
> 
> CONFIG_ATA_EXPERIMENTAL, CONFIG_NET_EXPERIMENTAL,
> CONFIG_VIDEO_EXPERIMENTAL, ... all being added by developers

yeah, i'd prefer that. People might be willing to enable an experimental 
video driver but not an experimental ATA driver. This global-scope "all 
or nothing" CONFIG_EXPERIMENTAL is totally pointless and _no_ distro 
uses it in practice.

If it's a pure label via which you want to document things as 
experimental then i'd agree with adding the "Warning: experimental code" 
to the help section of all the affected Kconfig entries (that way people 
would be more likely to actually read that label.)

but i think your suggestion of per-subsystem and/or per-driver quality 
levels is superior to that.

	Ingo
