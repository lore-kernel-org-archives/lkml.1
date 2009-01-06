Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZAFMic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZAFMic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZAFMiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:38:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZAFMiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:38:06 -0500
Date: Tue, 6 Jan 2009 13:37:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpumask: update local_cpus_show to use new cpumask
	API
Message-ID: <20090106123744.GE10319@elte.hu>
References: <20090105203351.785422000@polaris-admin.engr.sgi.com> <20090105203351.959649000@polaris-admin.engr.sgi.com> <200901051310.07147.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051310.07147.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Monday, January 5, 2009 12:33 pm Mike Travis wrote:
> > Impact: cleanup, reduce stack usage, use new cpumask API.
> >
> > Replace the local cpumask_t variable with a pointer to the
> > const cpumask that needs to be printed.
> >
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > ---
> >  drivers/pci/pci-sysfs.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Hm, clearly there are other patches in Ingo's tree that this depends on, 
> since this patch assumes the presence of cpumask_of_pcibus and has 
> slightly different cpumask_scnprintf context.  I'll just let Ingo push 
> the whole thing.

okay, will push them to Linus.

	Ingo
