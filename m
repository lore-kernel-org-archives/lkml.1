Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYGRXou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYGRXou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbYGRXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:44:24 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:57117 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757512AbYGRXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:44:21 -0400
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
From: Zachary Amsden <zach@vmware.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20080718224922.GB4507@linux-os.sc.intel.com>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <20080718105259.GY6875@elte.hu>
	 <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
	 <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
	 <20080718210348.GB24373@elte.hu>
	 <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
	 <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
	 <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com>
	 <20080718224922.GB4507@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 16:43:12 -0700
Message-Id: <1216424592.30348.33.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 15:49 -0700, Suresh Siddha wrote:

> > Thank you for cleaning this up Yinghai, but this really begs the
> > question - is having write_atomic REALLY worthwhile?
> 
> And this thread is about,  Maciej's cleanup patch which removed
> write_atomic completely :)
> 
> Thanks to Maciej who posted this fix. It was on my todo list for
> sometime now!

Awesome!  I just felt the need to use 'flaming crap' in a sentence
today, and broken APICs seemed like an easy target.  Glad to know it's
gone.

Zach

