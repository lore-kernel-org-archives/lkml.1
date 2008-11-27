Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYK0KaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYK0KaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYK0K34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:29:56 -0500
Received: from www.tglx.de ([62.245.132.106]:39990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYK0K3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:29:55 -0500
Date: Thu, 27 Nov 2008 11:29:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811271115370.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>  <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>  <20081126140054.GX6703@one.firstfloor.org>  <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>  <20081127100602.GF6703@one.firstfloor.org>
 <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, stephane eranian wrote:
> > Lockless buffers are nasty, but it works in oprofile at least.
> >
> > Taking out NMis in the first version at least seems like a reasonable
> > solution. After all you can still use standard oprofile where they work
> > just fine.
> >
> The only reason why I have to deal with NMI is not so much to allow
> for profiling irq-off regions but because I have to share the PMU with
> the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
> on the fly.

We can limit the functionality here. Fail or disable the NMI watchdog
are both valid solutions.

Thanks,

	tglx
