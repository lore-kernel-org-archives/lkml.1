Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYAVMWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYAVMWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYAVMVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:21:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYAVMVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:21:53 -0500
Date: Tue, 22 Jan 2008 13:20:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
Message-ID: <20080122122058.GC31253@elte.hu>
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080118203259.GA3079@elte.hu> <20080118213711.GA24979@elte.hu> <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com> <20080118220200.GA1071@elte.hu> <5d6222a80801181724p40bdedebgded1d43b052d168e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80801181724p40bdedebgded1d43b052d168e@mail.gmail.com>
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


* Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> On Jan 18, 2008 8:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Zachary Amsden <zach@vmware.com> wrote:
> >
> > > > but in exchange you broke all of 32-bit with CONFIG_PARAVIRT=y.
> > > > Which means you did not even build-test it on 32-bit, let alone boot
> > > > test it...
> > >
> > > Why are we rushing so much to do 64-bit paravirt that we are breaking
> > > working configurations?  If the developement is going to be this
> > > chaotic, it should be done and tested out of tree until it can
> > > stabilize.
> >
> > what you see is a open feedback cycle conducted on lkml. People send
> > patches for arch/x86, and we tell them if it breaks something. The bug
> > was found before i pushed out the x86.git devel tree (and the fix is
> > below - but this shouldnt matter to you because the bug never hit a
> > public x86.git tree).
> >
> >         Ingo
> >
> Other than this, it seems to build and boot fine.
> 
> Do you want me to resend ?

no, this was the only small problem i found, your series looks good to 
me and is included in latest x86.git.

	Ingo
