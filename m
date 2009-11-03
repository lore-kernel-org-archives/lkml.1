Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbZKCOCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbZKCOCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZKCOCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:02:30 -0500
Received: from smtp.nokia.com ([192.100.122.230]:39629 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZKCOC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:02:29 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/5] MFD: twl4030-codec: APLL_INFREQ handling in 
 =?iso-8859-1?q?the=09MFD?= driver
Date: Tue, 3 Nov 2009 16:02:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com> <200911031537.50430.peter.ujfalusi@nokia.com> <20091103134437.GA22501@sirena.org.uk>
In-Reply-To: <20091103134437.GA22501@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911031602.16074.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 03 Nov 2009 14:02:19.0365 (UTC) FILETIME=[41DDD950:01CA5C8E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009 15:44:38 ext Mark Brown wrote:
> > on board. Another reason is that we have other part of the twl, which
> > needs resources from the codec part, but it is not loaded through the
> > codec MFD, so providing the needed information is kind of tricky with
> > that setup.
> 
> I had thought that the sub-device was supposed to handle the arbitration
> and could be used here.

That would have been ideal. As such the audio and the Vibra interface is the 
only one directly inside of the codec part of twl, but there is a need for other 
modules to actually control resources within the codec part in order to operate, 
but they are not actually sub-devices of the codec MFD.

-- 
Péter
