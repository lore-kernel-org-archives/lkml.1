Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZKROlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZKROlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZKROll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:41:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39389 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757243AbZKROll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:41:41 -0500
Date: Wed, 18 Nov 2009 14:41:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
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
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
Message-ID: <20091118144145.GA16852@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
 <20091118133938.GE6592@rakim.wolfsonmicro.main>
 <20091118143609.GD2832@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118143609.GD2832@esdhcp037198.research.nokia.com>
X-Cookie: The greatest remedy for anger is delay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:36:09PM +0200, Eduardo Valentin wrote:

> But maybe these VINT* should be set as always_on in twl4030-regulator driver?

Can they support any external load at all?  If not then it would make
sense for the chip driver to at least provide a default set of
constraints for them rather than forcing all the machine drivers to do
it manually.
