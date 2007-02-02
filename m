Return-Path: <linux-kernel-owner+w=401wt.eu-S1423176AbXBBHV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423176AbXBBHV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXBBHV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:44763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423171AbXBBHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:27 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Date: Fri, 2 Feb 2007 08:07:01 +0100
User-Agent: KMail/1.9.5
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201202213.c7726d68.akpm@linux-foundation.org>
In-Reply-To: <20070201202213.c7726d68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020807.01514.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 February 2007 05:22, Andrew Morton wrote:
> On Thu, 01 Feb 2007 10:59:52 +0100 jbohac@suse.cz wrote:
> 
> > TSC-based x86_64 timekeeping implementation
> 
> I worry about the relationship between this work and all the time-management
> changes in -mm.  If Andi to were to merge all this stuff under that then I
> expect various catastrophes would ensue.
> 
> Have you checked to determine the severity of the overlaps?

The overlap is quite total. They both overhaul the time code completely. 

I suspect the way to go is to reimplement Jiri's patch on top of clock sources
(Hopefully now with working algorithms that shouldn't be too hard). But 
I'm still waiting for Jiri's assessment on how feasible this is.

-Andi
