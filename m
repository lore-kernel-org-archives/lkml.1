Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZKTKcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZKTKcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZKTKcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:32:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65161 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZKTKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:32:22 -0500
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
In-Reply-To: <20091120100633.GE3733@sortiz.org>
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com>
	 <20091118133938.GE6592@rakim.wolfsonmicro.main>
	 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
	 <20091118144145.GA16852@rakim.wolfsonmicro.main>
	 <4B04EDE8.1010906@nokia.com>
	 <20091119092412.GA4696@codecarver.research.nokia.com>
	 <20091119103054.GC9763@rakim.wolfsonmicro.main>
	 <20091120100633.GE3733@sortiz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 10:32:25 +0000
Message-ID: <1258713145.3640.11.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 11:06 +0100, Samuel Ortiz wrote:
> Hi Mark,
> 
> On Thu, Nov 19, 2009 at 10:30:54AM +0000, Mark Brown wrote:
> > On Thu, Nov 19, 2009 at 11:24:12AM +0200, Peter 'p2' De Schrijver wrote:
> > 
> > > VINTANA2 can be turned off if MADC, audio and USB are not used. 
> > 
> > Sounds like it'd be useful to add regulator support for those drivers,
> > then.
> > 
> > In any case, since nobody is using regulator_has_full_constraints()
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Would you mind carrying this one with your twl4030-mfd branch ? It doesnt
> apply cleanly to my tree due to the missing twl4030 patches from Peter.
> 
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Juha, this doesn't apply to regulator for-next either. Is it possible to
split it out into a patch for mfd and a patch for regulator (against
their for-next branches) ?

Thanks

Liam

