Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYGVSbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYGVSbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYGVSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:31:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGVSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:31:17 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080722181101.GC9508@redhat.com>
References: <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	 <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	 <1216325546.5515.63.camel@localhost.localdomain>
	 <20080717202634.GI18295@redhat.com>
	 <1216328769.5515.78.camel@localhost.localdomain>
	 <20080717213355.GJ18295@redhat.com>
	 <20080722140015.37628ea4@bree.surriel.com>
	 <20080722181101.GC9508@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 20:31:17 +0200
Message-Id: <1216751477.7257.115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 14:11 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Jul 22, 2008 at 02:00:15PM -0400, Rik van Riel wrote:
> > [...]
> > > Yes, that is generally desirable - each case is usually a question of
> > > cost/benefit.  One significant requirement for us is to keep working
> > > with older kernels.
> > 
> > You will have to weigh that against the benefits of making
> > systemtap generally useful for kernel developers [...]
> 
> Understood & agreed, Rik.  If an issue arises where there is genuine
> conflict between kernel-developer-usability and something else, we'll
> try to solve it favouring the former if at all possible.
> 
> (The kprobes addressing argument cannot reasonably be placed into this
> category.)

You have your viewpoint inverted, if the kernel developers think you
have a problem, and you fail to address it, they will walk away.

If you want the kernel people to endorse your project, you'll have to
please them. Its that simple. If that means having to radically
re-structure your design, and/or break backwards compatibility then so
be it. Such are the costs for not collaborating from the start.

If you stubbornly refuse to co-operate you'll either break the project
or invite a fork/rewrite by someone else if the idea is deemed
worthwhile enough.

