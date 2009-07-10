Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZGJUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZGJUex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZGJUeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:34:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55914 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbZGJUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:34:43 -0400
Date: Fri, 10 Jul 2009 16:34:33 -0400
From: Dave Jones <davej@redhat.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
Message-ID: <20090710203433.GA11105@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joao Correia <joaomiguelcorreia@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>,
	Amerigo Wang <xiyou.wangcong@gmail.com>
References: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com> <1247078066.16156.15.camel@laptop> <a5d9929e0907081232y2c043a05lff8868c3c5931e9e@mail.gmail.com> <a5d9929e0907081233s6fc42c15k710047a1b0dcc5bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0907081233s6fc42c15k710047a1b0dcc5bf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:33:37PM +0100, Joao Correia wrote:
 > On Wed, Jul 8, 2009 at 8:32 PM, Joao Correia<joaomiguelcorreia@gmail.com> wrote:
 > > On Wed, Jul 8, 2009 at 7:34 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
 > >> On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
 > >>> (Applies to current Linus tree, as of 2.6.31-rc2)
 > >>>
 > >>> A third limit becomes apparent as being too low after raising
 > >>> MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
 > >>> elusive to trigger.
 > >>
 > >> Would this involve reloading modules a lot?
 > >>
 > >>
 > >
 > > All the other limits were triggered immediatly upon boot. This one
 > > happens during regular system usage, after a couple of hours. Not
 > > loading more modules than needed, the system stays at around 45
 > > modules loaded, give or take. I do have qemu running, if that helps
 > > anything.
 > >
 > > Joao Correia
 > >
 > 
 > qemu running as a -host-, not the system running inside it. Just to clear it up.

Could you upload your /proc/lockdep someplace ? Maybe there's some obvious
clues in there like the ones we saw in mine.

	Dave

