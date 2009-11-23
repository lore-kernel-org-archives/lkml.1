Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZKWPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZKWPP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZKWPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:15:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:36802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZKWPP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:15:27 -0500
Date: Mon, 23 Nov 2009 16:15:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line size config options
Message-ID: <20091123151532.GB19175@wotan.suse.de>
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com> <20091116041407.GB5818@wotan.suse.de> <4B011677020000780001FD9D@vpn.id2.novell.com> <20091116105657.GE5818@wotan.suse.de> <20091119035640.GA18236@elte.hu> <20091118205240.11d3d660@infradead.org> <20091119081307.GA20534@wotan.suse.de> <20091119075958.2cba15f8@infradead.org> <20091123083459.GB11443@elte.hu> <20091123065201.564d4b16@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123065201.564d4b16@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:52:01AM -0800, Arjan van de Ven wrote:
> On Mon, 23 Nov 2009 09:34:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > On Thu, 19 Nov 2009 09:13:07 +0100
> > > Nick Piggin <npiggin@suse.de> wrote:
> > > > 
> > > > My other point was just this, but I don't care too much. But it is
> > > > worded pretty negatively. The key here is that increasing the
> > > > value too large tends to only cost a very small amount of size
> > > > (and no increase in cacheline foot print, only RAM). 
> > > 
> > > 128 has a pretty significant impact on TPC-C benchmarks.....
> > > it was the top issue until mainline fixed it to default to 64
> > 
> > Mind sending a patch that sets the default to 64 on NUMA too?
> > 
> > P4 based NUMA boxes are ... a bad memory to be forgotten.
> 
> this patch adds a regression. Linux defaulted to 64 since.. march or so.
> 
> now we go back to the old setting; Nick should fix that. Or at least
> extremely document and justify this change....

Oh well I didn't think the change to 128 should be done without
discussion, and I just raised my opinion. You did make some good
counter points so perhaps mainline is best to continue with 64.
However it would be nice to get to the bottom of why it cost
so much on your OLTP.
