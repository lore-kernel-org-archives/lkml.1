Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYDYPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYDYPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYDYPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:53:10 -0400
Received: from ns.store20.com ([212.7.7.16]:47367 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbYDYPxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:53:09 -0400
Subject: Re: [REGRESSION] x86: support for new UV apic
From: Priit Laes <plaes@plaes.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
In-Reply-To: <87abjixo7d.fsf@basil.nowhere.org>
References: <1209098600.3707.13.camel@localhost>
	 <20080425064405.GA23043@elte.hu>  <87abjixo7d.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Apr 2008 18:53:02 +0300
Message-Id: <1209138782.6899.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, R, 2008-04-25 kell 11:45, kirjutas Andi Kleen:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Priit Laes <plaes@plaes.org> wrote:
> >
> >> Hey,
> >> 
> >> I am getting two following warnings (probable one per each CPU core) 
> >> using the latest Linus's git:
> >> 
> >> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
> >> Modules linked in:
> >> Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20
> >
> > thanks - could you check the patch below, does it fix the warnings?
> 
> I think it would have been better to change the WARN_ON to
> 
> WARN_ON(preemptible() && num_online_cpus() > 1)
> 
> Preemption is actually ok here because this runs before the other
> CPUs are started
> 
> Alternative patch appended.

Worksforme :)

--
Priit Laes
