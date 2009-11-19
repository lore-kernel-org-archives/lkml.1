Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZKSJYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZKSJYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZKSJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:24:48 -0500
Received: from smtp.nokia.com ([192.100.122.233]:41361 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZKSJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:24:47 -0500
Date: Thu, 19 Nov 2009 11:24:12 +0200
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091119092412.GA4696@codecarver.research.nokia.com>
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com> <20091118133938.GE6592@rakim.wolfsonmicro.main> <20091118143609.GD2832@esdhcp037198.research.nokia.com> <20091118144145.GA16852@rakim.wolfsonmicro.main> <4B04EDE8.1010906@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B04EDE8.1010906@nokia.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-OriginalArrivalTime: 19 Nov 2009 09:24:15.0802 (UTC) FILETIME=[104C29A0:01CA68FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 08:04:08AM +0100, Keski-Saari Juha.1 (EXT-Teleca/Helsinki) wrote:
> ext Mark Brown wrote:
> > On Wed, Nov 18, 2009 at 04:36:09PM +0200, Eduardo Valentin wrote:
> > 
> >> But maybe these VINT* should be set as always_on in twl4030-regulator driver?
> > 
> > Can they support any external load at all?  If not then it would make
> > sense for the chip driver to at least provide a default set of
> > constraints for them rather than forcing all the machine drivers to do
> > it manually.
> 
>  From the TRM it appears that the max current output values are as follows
> 
> VINTANA1 - 30mA
> VINTANA2 - 250mA
> VINTDIG  - 100mA
> 
> Theoretically they may be able to support external load depending on your machine configuration but still I think providing constraints for them in 
> the chip driver could be a good idea since the "always-on" limitation is imposed by the chip and not the machine. Without these three supplies the TWL 
> does not function properly, if at all. Also worth noting is that the current implementation of RegulatorFW doesn't appear to be able to turn these 
> supplies off (comparing TWL register content with framework status).

VINTANA2 can be turned off if MADC, audio and USB are not used. 

Cheers,

Peter.
-- 
goa is a state of mind
