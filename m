Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYHWXxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYHWXxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 19:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYHWXxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 19:53:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYHWXxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 19:53:38 -0400
Date: Sat, 23 Aug 2008 16:53:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Joshua Hoblitt <josh@hoblitt.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
 16gb of memory is usable
Message-ID: <20080823165318.50ae9d8c@infradead.org>
In-Reply-To: <20080822062459.GO14110@elte.hu>
References: <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
	<20080822002952.GG23377@hoblitt.com>
	<20080822010014.GH23377@hoblitt.com>
	<20080822011055.GI23377@hoblitt.com>
	<86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	<20080822021512.GJ23377@hoblitt.com>
	<86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
	<86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com>
	<20080822035024.GB30284@elte.hu>
	<86802c440808212316t1c89321fl717fa80d2013f155@mail.gmail.com>
	<20080822062459.GO14110@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 08:24:59 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > > +               if (tmp != mask_lo) {
> > > +                       WARN_ON("mtrr: your BIOS has set up an
> > > incorrect mask, fixing it up.\n");
> > 
> > can you change WARN_ON to WARN_ON_ONCE ?
> 
> the commit below does that. Note that the condition is 
> WARN_ON(condition) or WARN(string) - WARN_ON(string) will just print
> a kernel stack unconditionally. Unfortunately there's no WARN_ONCE(). 
> (Arjan?)

Andrew removed that from the patches as "unused" :-(
oh well easy to add back ;-)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
