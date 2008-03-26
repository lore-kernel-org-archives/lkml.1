Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYCZHir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYCZHir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYCZHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:38:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYCZHih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:38:37 -0400
Date: Wed, 26 Mar 2008 08:38:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080326073823.GD3442@elte.hu>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325175657.GA6262@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> > > -        obj-y				+= genapic_64.o genapic_flat_64.o
> > > +        obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o
> > 
> > Definitely should be a CONFIG
> 
> Not sure that I understand why. The overhead of UV is minimal & we 
> want UV enabled in all distro kernels. OTOH, small embedded systems 
> probably want to eliminate every last bit of unneeded code.
> 
> Might make sense to have a config option. Thoughts????

i wouldnt mind having UV enabled by default (it can be a config option 
but default-enabled on generic kernels so all distros will pick this hw 
support up), but we definitely need the genapic unification before we 
can add more features.

	Ingo
