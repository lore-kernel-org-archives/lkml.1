Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZJSM7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZJSM7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZJSM7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:59:53 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55870 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZJSM7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:59:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/4] ASoC: TWL4030: Only update the needed bits in *set_dai_sysclk
Date: Mon, 19 Oct 2009 15:59:38 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "tony@atomide.com" <tony@atomide.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-4-git-send-email-peter.ujfalusi@nokia.com> <20091019125507.GA1417@rakim.wolfsonmicro.main>
In-Reply-To: <20091019125507.GA1417@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910191559.38478.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 19 Oct 2009 12:59:42.0021 (UTC) FILETIME=[061E6750:01CA50BC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 October 2009 15:55:08 ext Mark Brown wrote:
> On Mon, Oct 19, 2009 at 03:42:19PM +0300, Peter Ujfalusi wrote:
> > +	apll_ctrl = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
> > +	apll_ctrl &= ~TWL4030_APLL_INFREQ;
> >  	switch (freq) {
> 
> I'll apply this - it's idiomatic for the current driver - but you might
> want to look at snd_soc_update_bits() which does a read/modify/write
> cycle for you.
> 

Yeah, it is a good idea.
I'll address this when I go through the soc codec driver in my planned revisit 
and cleanup round quite soon.

Thanks,
Péter
