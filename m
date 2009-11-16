Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZKPPXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZKPPXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZKPPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:23:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56534 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZKPPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:23:51 -0500
Date: Mon, 16 Nov 2009 15:23:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "Leukkunen Lauri (Nokia-D/Helsinki)" <lauri.leukkunen@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Deak Imre (Nokia-D/Helsinki)" <imre.deak@nokia.com>,
       "Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>,
       "Kauppi Ari (EXT-Ixonos/Oulu)" <ext-ari.kauppi@nokia.com>,
       Jarkko Nikula <jhnikula@gmail.com>,
       "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
       "Tereshonkov Roman (Nokia-D/Helsinki)" <roman.tereshonkov@nokia.com>
Subject: Re: [PATCH v2 1/2] input: touchscreen: introduce tsc2005 driver
Message-ID: <20091116152354.GA29479@sirena.org.uk>
References: <1257340982-22814-1-git-send-email-aaro.koskinen@nokia.com> <20091114060332.GG4463@core.coreip.homeip.net> <20091116123748.GC28963@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116123748.GC28963@pcarmody-desktop>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 02:37:48PM +0200, Phil Carmody wrote:
> On 14/11/09 07:03 +0100, ext Dmitry Torokhov wrote:

> > Do we really need to do filtering and averaging in kernel? What about
> > tslib?

> Not everyone uses tslib. There's already some filtering in the tsc2005 
> already, but it's not really enough. This averaging also has the
> pleasant side-effect of reducing the number of input events. The
> fudging that takes place later has slightly different smoothing
> behaviour, and isn't a substitute.

If we do want to be doing filtering and averaging in kernel then it
really ought to be some sort of generic framework rather than driver
specific code since otherwise there will be duplication of effort.  The
OpenMoko guys were pushing a framework for doing that, I'm not sure what
the current status is.
