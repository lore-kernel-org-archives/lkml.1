Return-Path: <linux-kernel-owner+w=401wt.eu-S1764114AbXGZQVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764114AbXGZQVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbXGZQVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:21:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:45581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbXGZQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:21:36 -0400
Date: Thu, 26 Jul 2007 18:21:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726162134.GA13880@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de> <20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de> <20070726155444.GC15969@in.ibm.com> <20070726161431.GA32008@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726161431.GA32008@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernhard Walle <bwalle@suse.de> [2007-07-26 18:14]:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:54]:
> > 
> > That's true. Its not mainline. We had similar discussion in the past
> > also. I think we should allow only audited code to be run after panic().
> > Leaving it open to modules or unaudited code makes this solution
> > something like LKCD where whole lot of code used to run after the crash,
> > hence was unreliable.
> > 
> > If KDB goes mainline, then I think it is not a bad idea to call debugger
> > first (if it is enabled) and then one can trigger crash dump from inside
> > the debugger.
> 
> Well, after thinking again about this, I think the best solution would
> to call kdump from KDB with a command as it was done by LKCD.

Ok, but that doesn't solve the problem (it would solve the opposite
problem).

My question is: Why cannot kdump use the notifier call chain? Wouldn't
this simplify things in general, apart from KDB. Not talking about the
priority of kdump now ...


Thanks,
   Bernhard

