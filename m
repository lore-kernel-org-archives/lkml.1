Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZJUI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZJUI4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZJUI4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:56:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40579 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZJUI4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:56:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH 0/4] twl4030 codec as MFD device
Date: Wed, 21 Oct 2009 11:56:33 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
In-Reply-To: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910211156.33505.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 21 Oct 2009 08:56:38.0858 (UTC) FILETIME=[66B3D2A0:01CA522C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

On Monday 19 October 2009 15:42:16 Ujfalusi Peter (Nokia-D/Tampere) wrote:
> Hello,
> 
> The following series adds new MFD device on top of the twl4030 MFD device
>  for the codec part of the chip, and also converts the soc audio driver to
>  use the correct probing (device model).
> 
> Reason for the twl4030_codec MFD: the vibra control is actually in the
>  codec part of the twl4030. If both the vibra and the audio functionality
>  is needed from the twl4030 at the same time, than they need to control the
>  codec power and APLL at the same time without breaking the other driver.
> Also these two has to be able to work without the need for the other
>  driver.

Have you had time to look at the series?
I have made all the modification suggested by Mark Brown, and I'm holding back 
the second series (to have the comments from you for the initial series), so I 
can address those in the same round.

Thank you,
Péter
