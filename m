Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZDPKd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZDPKd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZDPKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:33:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZDPKdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:33:13 -0400
Date: Thu, 16 Apr 2009 12:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: djwong@us.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Fix regression where _PPC is not read at boot
	even when ignore_ppc=0
Message-ID: <20090416103258.GR9813@elte.hu>
References: <20090415225348.GW8311@plum> <20090416002712.GX8311@plum> <200904161201.13409.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904161201.13409.trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> The *reevaluate* implies that the _PPC value has been 
> evaluated/initialized by the OS already and Ingo's patch would be 
> wrong then. I'd like to have a look at the T60's ACPI parts and 
> find out what exactly (or if at all) makes _PPC to return sane 
> values, I expect it's _PDC.
> 
> Hmm, I could also imagine that Ingo's T60 patch is not needed 
> anymore since Yakui's patch 
> (0ac3c571315a53c14d2733564f14ebdb911fe903). This one could make 
> sure that _PDC is evaluated first making the internal ACPI _PPC 
> state initialize and makes sure _PPC gets only called afterwards.
> 
> If this patch does not break Ingo's T60, I think this should go 
> in. Due to Yakui's reordering/cleanup of ACPI function calls, I 
> think also the notifier chain I introduced is not needed anymore 
> and I can clean this up if I find some time.

Feel free to do so, if it's expected to work. I'll let you know if 
it breaks the T60 box - i still have it in the -tip test mix.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
