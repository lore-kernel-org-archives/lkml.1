Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYFZNXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYFZNXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYFZNXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:23:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41682 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYFZNXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:23:20 -0400
Date: Thu, 26 Jun 2008 15:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       vgoyal@redhat.com
Subject: Re: [PATCH] x86: Limit E820 map when a user-defined memory map is
	specified
Message-ID: <20080626132257.GD18444@elte.hu>
References: <1214422756-10923-1-git-send-email-bwalle@suse.de> <86802c440806251259o6b1b1038v9f645992415f0372@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806251259o6b1b1038v9f645992415f0372@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Wed, Jun 25, 2008 at 12:39 PM, Bernhard Walle <bwalle@suse.de> wrote:
> > This patch brings back limiting of the E820 map when a user-defined
> > E820 map is specified. While the behaviour of i386 (32 bit) was to limit
> > the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
> > limit.
> >
> > That patch limits the E820 map again for both x86 architectures.
> >
> > Code was tested for compilation and booting on a 32 bit and 64 bit system.
> >
> >
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/unify-setup - thanks.

	Ingo
