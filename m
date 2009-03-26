Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZCZJNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZCZJNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZCZJNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:13:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZCZJNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:13:11 -0400
Date: Thu, 26 Mar 2009 10:11:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090326091153.GB9369@elte.hu>
References: <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain> <49CAC543.5020205@goop.org> <20090326003154.GA10614@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326003154.GA10614@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> > unsynchronized_tsc() just returns a guess anyway, and if you 
> > don't have X86_FEATURE_CONSTANT_TSC set, then it will return 
> > unstable for your hardware anyway, even without the 
> > is_vsmp_box() test.
> 
> Unfortunately we use hardware which has X86_FEATURE_CONSTANT_TSC.
> 
> >
> > Failing that, you could add yourself to bad_tsc_dmi_table[] and 
> > have that mark the tsc as unstable (you have DMI, right?).
> >
> 
> Newer versions of the VMM does, but older ones don't :(, and 
> obviously we have older versions out in the field that still needs 
> to be supported.

But those old versions wont have X86_FEATURE_CONSTANT_TSC set, 
right?

	Ingo
