Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZKCNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZKCNoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZKCNog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:44:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51100 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZKCNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:44:36 -0500
Date: Tue, 3 Nov 2009 13:44:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 3/5] MFD: twl4030-codec: APLL_INFREQ handling in the
	MFD driver
Message-ID: <20091103134437.GA22501@sirena.org.uk>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com> <1257165295-9352-4-git-send-email-peter.ujfalusi@nokia.com> <20091102173035.GC8546@rakim.wolfsonmicro.main> <200911031537.50430.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911031537.50430.peter.ujfalusi@nokia.com>
X-Cookie: I've got a bad feeling about this.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> on board. Another reason is that we have other part of the twl, which needs 
> resources from the codec part, but it is not loaded through the codec MFD, so 
> providing the needed information is kind of tricky with that setup.

I had thought that the sub-device was supposed to handle the arbitration
and could be used here.  But like we said, it's not going to make any
difference in the grand scheme of things.
