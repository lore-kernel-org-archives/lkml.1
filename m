Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbYD3M5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbYD3M5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYD3M4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:56:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759579AbYD3M4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:56:49 -0400
Date: Wed, 30 Apr 2008 05:55:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: <andi-suse@firstfloor.org>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <mtk.manpages@gmail.com>, <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Message-Id: <20080430055539.803fa559.akpm@linux-foundation.org>
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401CE20DA@swsmsx413.ger.corp.intel.com>
References: <20080430135440.A359@sedona.ch.intel.com>
	<20080430052631.3d182670.akpm@linux-foundation.org>
	<029E5BE7F699594398CA44E3DDF5544401CE20DA@swsmsx413.ger.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 13:43:20 +0100 "Metzger, Markus T" <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> >Sent: Mittwoch, 30. April 2008 14:27
> >To: Metzger, Markus T
> 
> >> Provide an in-kernel interface to Branch Trace Store and 
> >implement the
> >> ptrace user interface on top of it.
> >> 
> >> Fix a few bugs that were detected during the perfmon2 adaptation to
> >> the DS interface by Stephane Eranian.
> >> 
> >> The ptrace implementation becomes a rather thin layer that only
> >> forwards requests.
> >> 
> >> The BTS interface may later be morphed into a utrace interface for
> >> execution trace, or it may be used to implement such a utrace
> >> interface on top of it.
> >
> >This appears to be against a version of x86-ptrace-pebs-support
> >which I don't have.
> >
> >I dropped everything - let's start again.
> 
> That was against x86.git#latest.

oh, ok.  Hopefully this run-multiple-trees-to-confuse-everyone problem will
go away soon.

> Do you want me to send patches against some other git? Which one?

I'll let you and Ingo sort it out.
