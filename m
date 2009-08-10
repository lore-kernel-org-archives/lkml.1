Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZHJJoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZHJJoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZHJJoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:44:00 -0400
Received: from d1.icnet.pl ([212.160.220.21]:40066 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZHJJoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:44:00 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [RFC] [PATCH 3/3] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter
Date: Mon, 10 Aug 2009 11:43:25 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200908101050.08074.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101143.26542.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday 10 August 2009 10:50:06 Janusz Krzysztofik wrote:
> Enhance period index accuracy, particularly just before buffer rewind, by
> making use of DMA interrupt status flags in addition to simply counting
> interrupts

Sorry, this one is still buggy an can break other OMAP models. Please, do not 
apply, but wait for next version. However, comments are welcome.

The bug hits when multiple interrupt flags are set in parallel.

Thanks,
Janusz
