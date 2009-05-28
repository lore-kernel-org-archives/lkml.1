Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZE1APS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZE1APS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZE1APE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:15:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbZE1APC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:15:02 -0400
Date: Thu, 28 May 2009 02:13:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, George Dunlap <George.Dunlap@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Message-ID: <20090528001350.GD26820@elte.hu>
References: <4A1C3453.6080402@redhat.com> <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > The Linux scheduler already supports multiple scheduling 
> > classes.  If we find that none of them will fit our needs, we'll 
> > propose a new one.  When the need can be demonstrated to be 
> > real, and the implementation can be clean, Linux can usually be 
> > adapted.
> 
> But that's exactly George and Jeremy's point.  KVM will eventually 
> require changes that clutter Linux for purposes that are relevant 
> only to a hypervisor.

That's wrong. Any such scheduler classes would also help: control 
groups, containers, vserver, UML and who knows what other isolation 
project. Many of such mechanisms are already implemented as well.

I rarely see any KVM-only feature in generic kernel code, and that's 
good.

Xen changes - especially dom0 - are overwhelmingly not about 
improving Linux, but about having some special hook and extra 
treatment in random places - and that's really bad.

I also find it pretty telling that you cut out the most important 
point of Avi's reply:

> > I think the Xen design has merit if it can truly make dom0 a 
> > guest -- that is, if it can survive dom0 failure.  Until then, 
> > you're just taking a large interdependent codebase and splitting 
> > it at some random point, but you don't get any stability or 
> > security in return.

that crucial question really has to be answered honestly and 
upfront.

	Ingo
