Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXLVNCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXLVNCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXLVNBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:01:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52712 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXLVNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fqkB7vHdYylGnw7Jo+NYRzi/ZCSaVwi1pq1l6SpF35KpsTjQ8RelWknnuUSvvyr6PTZhr973uNxJsAIHX/OGtfkd0aV1U4LBIXUcIJdzYyHeMgu/Y/mSlYUtYcvESOZOcsqrfX/HwABf1gieJE794uTMSFwZ2Y8Te0KLan8EtFw=
Date: Sat, 22 Dec 2007 16:01:41 +0300
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222130141.GB1738@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <20071222123705.GA14767@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222123705.GA14767@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > the rule is very simple: unless you have really, really, really, REALLY 
> > good reasons, just dont break stuff.

Could we please drop "kset: move /sys/slab to /sys/kernel/slab" from -mm?
Old slabinfo complains that SLUB_DEBUG is not on and refuses to do anything.
