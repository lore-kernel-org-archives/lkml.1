Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYIXIex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYIXIex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIXIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:34:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYIXIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:34:46 -0400
Date: Wed, 24 Sep 2008 10:34:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - V2 Add early detection of UV system types
Message-ID: <20080924083436.GB5576@elte.hu>
References: <20080923182817.GA6335@sgi.com> <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com> <20080923193049.GA21605@sgi.com> <86802c440809231239o207c893ja508a1574bd04706@mail.gmail.com> <20080923203713.GA9606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923203713.GA9606@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> Portions of the ACPI code needs to know if a system is a UV system prior
> to genapic initialization. This patch adds a call early_acpi_boot_init()
> so that the apic type is discovered earlier.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> 
> V2 of the patch adding fixes from Yinghai Lu.
> Much cleaner and smaller.

applied to tip/x86/uv, thanks!

	Ingo
