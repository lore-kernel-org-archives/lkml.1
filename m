Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZJTMBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZJTMBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZJTMBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:01:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:41692 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZJTMBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:01:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4] ASoC: TWL4030: Driver registration via twl4030_codec MFD
Date: Tue, 20 Oct 2009 15:01:28 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "tony@atomide.com" <tony@atomide.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <200910201430.49223.peter.ujfalusi@nokia.com> <20091020115106.GB2909@rakim.wolfsonmicro.main>
In-Reply-To: <20091020115106.GB2909@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910201501.28160.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 20 Oct 2009 12:01:31.0708 (UTC) FILETIME=[1024A7C0:01CA517D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009 14:51:06 ext Mark Brown wrote:
> Sure, though I suspect patch 3 could just be split in two happily with
> an include.  I don't really mind either way.  If you are going to keep
> them as one patch it'd be good to call out the move in the changelog.

I'll split the soc codec patch to two, one is changing the header the other is 
for the change in the codec driver.

> That's a good enough reason to leave things as they are, though really
> if you're building SND_SOC_ALL_CODECs in a production system you're
> being a bit strange.

Fair enough.

> >
> >  +MODULE_ALIAS("platform:twl4030_codec_audio");
> 
> Yes.  The aliasing makes no reference to the parents of the device, it
> only cares about the device name - for the purposes of module loading
> and driver matching it's identical to any other platform device.

Good to know, I'll change this as well.

Thanks,
Péter
