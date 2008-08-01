Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbYHAHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbYHAHaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYHAHa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:30:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:48018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYHAHa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:30:28 -0400
Subject: Re: 2.6.27-rc1 process time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080801T025718-689@post.gmane.org>
References: <20080731104319.GB5806@ics.muni.cz>
	 <20080731144147.82fcd85e.akpm@linux-foundation.org>
	 <loom.20080801T025718-689@post.gmane.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 09:30:28 +0200
Message-Id: <1217575828.8157.114.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 03:03 +0000, Parag Warudkar wrote:
> Andrew Morton <akpm <at> linux-foundation.org> writes:
> 
> > 
> > On Thu, 31 Jul 2008 12:43:19 +0200
> > Lukas Hejtmanek <xhejtman <at> ics.muni.cz> wrote:
> > 
> > > Hello,
> > > 
> > > I think there is a regression since 2.6.26 in time accounting of processes.
> > 
> > Could be - we changed quite a bit.
> > 
> > > kthreadd and console-kit-daemons claim they spent 5124095 hours using CPU.
> > 
> > My 2.6.27-rc1-mm1 kthreadd looks OK in `top'.  How are you displaying
> > this information?  More details if possible, please..
> > 
> 
> Top's doing crazy things on my machine too after booting 2.6.27-rc1 - like Xorg
> showing 859% CPU usage on 4 CPU machine and generally any process running even
> shortly shows up as using anywhere between 100 and 150% CPU.
> 
> This is on x86 - Q6600 6Gb RAM. Let me know if anything else would be
> interesting to know.

Can you test with tip/sched/clock ?

