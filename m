Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYBOP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYBOP1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYBOP1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:27:05 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42505 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYBOP1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:27:02 -0500
Date: Fri, 15 Feb 2008 16:27:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 0/4] Voltage and current regulator framework
Message-ID: <20080215152711.GM1178@uranus.ravnborg.org>
References: <1203084641.3466.210.camel@localhost.localdomain> <20080215152451.GL1178@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215152451.GL1178@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:24:51PM +0100, Sam Ravnborg wrote:
> On Fri, Feb 15, 2008 at 02:10:41PM +0000, Liam Girdwood wrote:
> > This patch series provides a generic framework to allow device drivers
> > to control voltage and current regulators on SoC based devices (e.g.
> > phones, gps, media players).
> > 
> > The intention is to allow systems to dynamically control regulator
> > output in order to save power and prolong battery life. This applies to
> > both voltage regulators (where voltage output is controllable) and
> > current sinks (where current output is controllable).
> > 
> > The framework is designed around SoC based devices but may also be
> > relevant to non SoC devices. It's also been designed against two Power
> > Management ICs (PMICs) currently on the market - namely the Freescale
> > MC13783 and the Wolfson WM8350. However it is quite generic and should
> > apply to all PMICs. 
> 
> General comments related to your patch submission - not to the code.

And please run your patches through scripts/checkpatch.pl and fix
the obvious issues.

	Sam
