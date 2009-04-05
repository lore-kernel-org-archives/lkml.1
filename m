Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZDECjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZDECjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZDECjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 22:39:03 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:29949 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZDECjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 22:39:01 -0400
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen for 2.6.30 #2
From: William Pitcock <nenolod@dereferenced.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090403173623.GB6295@elte.hu>
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org>
	 <20090331185541.GA17807@elte.hu> <49D2713D.6090401@goop.org>
	 <20090403173623.GB6295@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 21:38:54 -0500
Message-Id: <1238899134.5814.172.camel@petrie>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-04-03 at 19:36 +0200, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> >> You know our stance which is very simple: dont put in Xen-only 
> >> hooks that slow down native, and get rid of the existing Xen-only 
> >> hooks.
> >
> > Yes, I understand that.  Unlike the pvops stuff, the dom0 changes 
> > are largely all init-time and setup, and so have no performance 
> > impact.
> 
> Yes, but once dom0 goes in your incentive to fix the native kernel 
> performance drain we accumulated along the years of paravirt layers 
> will be strongly weakened, right? :)
> 

There's plenty of incentive for everyone who has a stake in this thing
to ensure that paravirt performs equally to native. I do not see how you
could be legitimately concerned about that.

Are you saying that you are intentionally blocking dom0 work from
progressing (and thus alienating many enterprise linux users who have
millions of $ on hardware running Xen where switching to KVM is simply
NOT an option) because you feel that paravirt performance will not be
improved?

Regardless of however many kernel developers claim that KVM is an
enterprise-capable solution, it simply isn't. It may be at some point,
but that point is not today. Please let us have some modern hardware
support and features for our xen-based server clusters (well, without
forward-porting the 2.6.18 patchset) and stop this political bullshit.

William

