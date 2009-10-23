Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZJWF2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZJWF2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZJWF2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:28:03 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30788 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZJWF2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:28:02 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4 v2] ASoC: TWL4030: Driver registration via twl4030_codec MFD
Date: Fri, 23 Oct 2009 08:27:55 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
References: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com> <1256207208-25010-5-git-send-email-peter.ujfalusi@nokia.com> <20091022165643.GA28051@rakim.wolfsonmicro.main>
In-Reply-To: <20091022165643.GA28051@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910230827.55141.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 23 Oct 2009 05:27:59.0240 (UTC) FILETIME=[95413880:01CA53A1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 October 2009 19:56:44 ext Mark Brown wrote:
> On Thu, Oct 22, 2009 at 01:26:48PM +0300, Peter Ujfalusi wrote:
> > Change the way how the twl4030 soc codec driver is
> > loaded/probed.
> > Use the device probing via tlw4030_codec MFD device.
> 
> I'm OK with the series but:
> > @@ -147,6 +147,7 @@ config SND_SOC_TLV320DAC33
> >  	tristate
> >
> >  config SND_SOC_TWL4030
> > +	select TWL4030_CODEC
> >  	tristate
> 
> due to Kconfig ignoring dependencies all the individual machine drivers
> are going to need to select this, and SND_SOC_ALL_CODECS will need to
> select it if the MFD core is enabled.  I should be able to fix this up
> myself so no need to repost for that alone.

Hmm, what do you mean by that?
I have checked it, and selecting the machine driver will enables the MFD_CORE 
and TWL4030_CODEC in .config, also disabling the machine driver will also 
disable the MFD_CORE and the TWL4030_CODEC.

Can you go into details?

-- 
Péter
