Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZJWM7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZJWM7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZJWM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:59:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34010 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZJWM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:59:30 -0400
Date: Fri, 23 Oct 2009 13:59:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 4/4 v2] ASoC: TWL4030: Driver registration
	via twl4030_codec MFD
Message-ID: <20091023125930.GA8198@sirena.org.uk>
References: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com> <1256207208-25010-5-git-send-email-peter.ujfalusi@nokia.com> <20091022165643.GA28051@rakim.wolfsonmicro.main> <200910230827.55141.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910230827.55141.peter.ujfalusi@nokia.com>
X-Cookie: She's genuinely bogus.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 08:27:55AM +0300, Peter Ujfalusi wrote:

> Hmm, what do you mean by that?
> I have checked it, and selecting the machine driver will enables the MFD_CORE 
> and TWL4030_CODEC in .config, also disabling the machine driver will also 
> disable the MFD_CORE and the TWL4030_CODEC.

> Can you go into details?

Kconfig has never guaranteed to pay any attention to dependencies of
things that were enabled as a result of a select statement - they would
be silently ignored.  I've done some tests and it does seem that this is
doing what would be expected at the minute but looking at the Kconfig
changelogs I can't see anything that makes this an intentional change.
