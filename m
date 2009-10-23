Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZJWXzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZJWXzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZJWXzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:55:53 -0400
Received: from d1.icnet.pl ([212.160.220.21]:53569 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZJWXzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:55:52 -0400
X-Greylist: delayed 2592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 19:55:52 EDT
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>, Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH 05/10] omap1: Fix DSP public peripherals support for ams-delta
Date: Sat, 24 Oct 2009 01:11:07 +0200
User-Agent: KMail/1.9.10
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20091022221013.27408.443.stgit@localhost> <4AE0E938.7080305@ti.com> <20091023191939.GJ16230@atomide.com>
In-Reply-To: <20091023191939.GJ16230@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910240111.10604.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friday 23 October 2009 21:19:40 Tony Lindgren napisał(a):
> * Jon Hunter <jon-hunter@ti.com> [091022 16:22]:
> >
> > Tony Lindgren wrote:
> >> From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> >>
> >> DSP public peripherals used to work on OMAP1510 based (or all OMAP1 class?)
> >> machines as long as old dspgateway code were present in the l-o tree. For
> >> several months it is no longer included, breaking support for McBSP1 based
> >> audio on Amstrad Delta, for example.
> >>
> >> This patch, derived from the old dspgateway code, corrects the problem for the
> >> board by simply taking the DSP out of reset state, I guess. That way, things
> >> should not break when a new dsp code is added to the tree, and the change can
> >> be reverted then.
> >
> > A minor comment/correction here. Although this bit is called "DSP_RST"  
> > this does not actually release the DSP from reset. This bit actually  
> > releases the reset for the "priority registers (TIPB module), EMIF  
> > configuration registers, and the MPUI control logic (partially) in the  
> > DSP", thus allowing you to access the DSP peripherals via the MPUI. Bit  
> > 1 of the same register, called "DSP_EN", actually releases the DSP reset.
> 
> Thanks for clarifying that.

Forgive me my ignorance: do you think that there is still an option of putting any related piece of hardware in an idle state, as you, Tony, has suggested before for the DSP itslef?

Thanks,
Janusz
