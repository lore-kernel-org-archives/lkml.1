Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZKROgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZKROgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbZKROgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:36:40 -0500
Received: from smtp.nokia.com ([192.100.122.230]:57525 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbZKROgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:36:38 -0500
Date: Wed, 18 Nov 2009 16:36:09 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091118143609.GD2832@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
 <20091118133938.GE6592@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118133938.GE6592@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Nov 2009 14:36:18.0595 (UTC) FILETIME=[7D89E730:01CA685C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 02:39:39PM +0100, Mark Brown wrote:
> On Wed, Nov 18, 2009 at 01:46:35PM +0200, Juha Keski-Saari wrote:
> > This patch adds all the remaining TWL4030 regulators into the implementation,
> > also adding VINT* regulators in this way since they can be derived out from
> > the TWL
> > 
> > Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
> 
> This is fine from an API point of view but I worry that if any of the
> boards are using regulator_has_full_constraints() then this will break
> them by causing them to be powered off at the end of init.  Have you
> checked the in-tree twl4030 users for this?

Looks like no one is using the regulator_has_full_constraints(). At least the twl4030 users.

But maybe these VINT* should be set as always_on in twl4030-regulator driver?

-- 
Eduardo Valentin
