Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZKRNjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZKRNjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZKRNje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:39:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbZKRNje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:39:34 -0500
Date: Wed, 18 Nov 2009 13:39:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
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
Message-ID: <20091118133938.GE6592@rakim.wolfsonmicro.main>
References: <4B03DE53.6010007@nokia.com>
 <4B03DE9B.40800@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B03DE9B.40800@nokia.com>
X-Cookie: May explode if improperly recharged.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 01:46:35PM +0200, Juha Keski-Saari wrote:
> This patch adds all the remaining TWL4030 regulators into the implementation,
> also adding VINT* regulators in this way since they can be derived out from
> the TWL
> 
> Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>

This is fine from an API point of view but I worry that if any of the
boards are using regulator_has_full_constraints() then this will break
them by causing them to be powered off at the end of init.  Have you
checked the in-tree twl4030 users for this?
