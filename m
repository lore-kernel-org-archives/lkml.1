Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbXEIIbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbXEIIbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXEIIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:31:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbXEIIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:31:36 -0400
Date: Wed, 9 May 2007 01:31:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070509013119.dbea7233.akpm@linux-foundation.org>
In-Reply-To: <20070509012257.ceb825c4.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	<20070430102852.042964000@linutronix.de>
	<20070505003421.00ec45ba.akpm@linux-foundation.org>
	<20070505115127.GA17815@elte.hu>
	<1178463784.31213.46.camel@localhost.localdomain>
	<20070508225920.258d8d34.akpm@linux-foundation.org>
	<20070509001032.dbb982ca.akpm@linux-foundation.org>
	<1178698697.3042.461.camel@localhost.localdomain>
	<20070509012257.ceb825c4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 01:22:57 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 09 May 2007 10:18:17 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Wed, 2007-05-09 at 00:10 -0700, Andrew Morton wrote:
> > > > > find an updated patch below. It fixes the problem on Ingo's
> > > > > VAIO-of-fun-emulator and I got confirmation from several other affected
> > > > > users, that the patch series is still solving their problems.
> > > > > 
> > > > 
> > > > The machine is still hanging with this patch applied.
> > 
> > What did change since yesterday ?
> 
> I suspect I just tested the wrong thing yesterday.  Let me recheck just
> these patches against 2.6.21.

yup, same hang with just these three:

origin
clocksource-fix-resume-logic
clockevents-fix-resume-logic-updated-version
