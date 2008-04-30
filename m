Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbYD3QAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbYD3QAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYD3P7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:59:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53733 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbYD3P7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:59:54 -0400
Date: Wed, 30 Apr 2008 18:06:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, andi-suse@firstfloor.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, "Villacis, Juan" <juan.villacis@intel.com>
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Message-ID: <20080430160611.GD20451@one.firstfloor.org>
References: <20080430135440.A359@sedona.ch.intel.com> <20080430130305.GC20451@one.firstfloor.org> <029E5BE7F699594398CA44E3DDF5544401CE236A@swsmsx413.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401CE236A@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >I'm not quite sure on the kernel interface. How would a in kernel
> >subsystem use it for tracing itself for example?
> 
> The task parameter would be current.
> 
> Apart from that, you would use it the same way it is used in
> arch/x86/kernel/ptrace.c.

Hmm, sounds a little too complicated. Surely that could be easier?

> 
> You would want to bts_configure() it to disable tracing before you start
> reading your own BTS buffer.

I would suggest to write a simple example and put it with some overview
into Documentation

-Andi


