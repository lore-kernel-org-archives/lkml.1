Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbXLVXcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbXLVXcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 18:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbXLVXcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 18:32:32 -0500
Received: from mx2.math.uh.edu ([129.7.128.33]:38276 "EHLO mx2.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbXLVXcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 18:32:31 -0500
X-Greylist: delayed 2326 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 18:32:31 EST
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	<alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	<Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	<1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	<Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	<20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	<20071222100326.GF26157@elte.hu>
	<alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
	<20071222190933.GA2958@elte.hu>
From: Jason L Tibbitts III <tibbs@math.uh.edu>
Date: 22 Dec 2007 16:52:56 -0600
In-Reply-To: <20071222190933.GA2958@elte.hu>
Message-ID: <ufaabo2xrxz.fsf@epithumia.math.uh.edu>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "IM" == Ingo Molnar <mingo@elte.hu> writes:

IM> Distros will likely pick SLUB if there's no performance worries
IM> and if it's the default. Fedora rawhide already uses SLUB.

Actually, it seems to me that not only does Fedora rawhide use SLUB,
but Fedora 8 and 7 use it as well.  They don't have /proc/slabinfo and
they all seem to have CONFIG_SLUB=y:

> grep -r CONFIG_SLUB=y kernel
kernel/devel/config-generic:CONFIG_SLUB=y
kernel/F-7/configs/config-generic:CONFIG_SLUB=y
kernel/F-8/config-generic:CONFIG_SLUB=y

 - J<
