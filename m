Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZFKRN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZFKRN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFKRNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:13:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38964 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZFKRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:13:19 -0400
Date: Thu, 11 Jun 2009 18:12:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611171259.GW8633@ZenIV.linux.org.uk>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:05:02AM -0700, Ray Lee wrote:
> On Thu, Jun 11, 2009 at 10:00 AM, Christoph Hellwig<hch@infradead.org> wrote:
> > On Thu, Jun 11, 2009 at 06:56:18PM +0200, Peter Zijlstra wrote:
> >> No, once a kernel with this syscall gets released we most certainly
> >> intend to maintain its ABI.
> >
> > So what point is there in keeping it in-tree except making life hell for
> > packagers?
> 
> Packagers are quite used to taking a single source tree and building
> multiple packages out of it. This isn't rocket science. It's the
> multiple separate trees that need to be released in lock-step that are
> headaches.

Wrong.  Remember the fun bisecting around sysfs/udev incompatible change?
Oops, went back past the cutoff line, got to downgrade udev for the next
boot.  Oh, it oopses?  Too fucking bad, can't just boot the previous kernel,
should've kept _two_ working ones so that with any userland state we could
come back to working system.

This isn't a rocket science, this is a goddamn load of horse manure.
Packages that need to be updated in the lock-step *are* headaches from
hell when you are trying to do development.  Even if you have all of
them already built.
