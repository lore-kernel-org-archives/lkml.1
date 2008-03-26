Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYCZHac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYCZHac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCZHaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:30:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYCZHaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:30:23 -0400
Date: Wed, 26 Mar 2008 08:29:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jack Steiner <steiner@sgi.com>,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080326072945.GC3442@elte.hu>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080325180616.GX2170@one.firstfloor.org> <47E9B398.3080008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E9B398.3080008@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andi Kleen wrote:
>> No instead of having lots of if (xyz_system) do_xyz_special()
>> go through smp_ops for the whole thing so that UV would just have a 
>> special smp_ops that has special implementions or wrappers. 
>> Oops I see smp_ops are currently only implemented
>> for 32bit. Ok do it only once smp_ops exist on 64bit too.   
>
> I think glommer has patches to unify smp stuff, which should include 
> smp_ops.

yep, x86.git/latest has all that work included.

	Ingo
