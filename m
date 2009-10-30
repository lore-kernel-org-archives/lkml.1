Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZJ3GHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZJ3GHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 02:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZJ3GHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 02:07:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:56917 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbZJ3GHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 02:07:36 -0400
Subject: Re: [GIT PULL] perf_event/tracing/powerpc patches from Anton
 Blanchard
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <20091029065501.GB12874@elte.hu>
References: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
	 <20091029065501.GB12874@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 17:04:09 +1100
Message-ID: <1256882649.6372.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 07:55 +0100, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Here is a series of patches from Anton Blanchard that implement some 
> > nice tracing and perf_event features on powerpc.  One of them is 
> > generic perf_event stuff (adding software events for alignment faults 
> > and instruction emulation faults).
> > 
> > Since this touches the perf_event and tracing subsystems as well as 
> > the powerpc architecture code, I think the best way forward is for 
> > both Ingo and Ben to pull it into their trees.  I have based it on the 
> > most recent point in Linus' tree that Ingo had pulled into his perf 
> > branches (as of yesterday or so).
> 
> The generic perf bits look good to me - can pull it if Ben OKs the 
> PowerPC bits.

Yup. Just went through all of them, they look fine. I also test built on
a number of default configs and it seems to pass.

Cheers,
Ben.

