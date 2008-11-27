Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYK0Lww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYK0Lww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYK0Lwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:52:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYK0Lwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:52:43 -0500
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
	 <20081127100602.GF6703@one.firstfloor.org>
	 <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Nov 2008 12:52:26 +0100
Message-Id: <1227786746.4454.1468.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 12:35 +0100, stephane eranian wrote:
> On Thu, Nov 27, 2008 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> The only reason why I have to deal with NMI is not so much to allow
> >> for profiling irq-off regions but because I have to share the PMU with
> >> the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
> >> on the fly.
> >
> > The NMI watchdog is now off by default so failing with it enabled
> > is fine.
> 
> Yes, but most likely it is on in distro kernels.

So? You can disable it on the fly when there is a perfmon user.
