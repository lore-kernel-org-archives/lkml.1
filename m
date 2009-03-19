Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbZCSSOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbZCSSOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZCSSNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:13:51 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55059 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbZCSSNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:13:50 -0400
Subject: Re: [patch] twl4030-regulator: expose VPLL2
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: dbrownell@users.sourceforge.net, OMAP <linux-omap@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
In-Reply-To: <20090316155103.GJ16539@sirena.org.uk>
References: <200903131754.54997.david-b@pacbell.net>
	 <20090316155103.GJ16539@sirena.org.uk>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 18:13:46 +0000
Message-Id: <1237486426.6781.345.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 15:51 +0000, Mark Brown wrote:
> On Fri, Mar 13, 2009 at 05:54:54PM -0700, David Brownell wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Add VPLL2 to the set of twl4030-family regulators exposed for
> > use by various drivers.  It's commonly used to power the digital
> > video outputs (e.g. LCD or DVI displays) on OMAP3 systems.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Samuel, I've applied this to the regulator tree as the part that touches
mfd is relatively minor and twl4030 specific (doesn't touch core).

Thanks

Liam

