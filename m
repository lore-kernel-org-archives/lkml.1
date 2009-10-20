Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZJTLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZJTLQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZJTLQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 07:16:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:36810 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZJTLQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 07:16:31 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new 
 =?iso-8859-1?q?child=09to_the?= core
Date: Tue, 20 Oct 2009 14:16:15 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com> <20091020100334.GA28592@opensource.wolfsonmicro.com>
In-Reply-To: <20091020100334.GA28592@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910201416.15172.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 20 Oct 2009 11:16:20.0895 (UTC) FILETIME=[C05F6AF0:01CA5176]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009 13:03:34 ext Mark Brown wrote:
> On Mon, Oct 19, 2009 at 03:42:17PM +0300, Peter Ujfalusi wrote:
> > New MFD child to twl4030 MFD device.
> > This MFD device will be used by the drivers, which needs resources
> > from the twl4030 codec like audio and vibra.
> >
> > The platform specific configuration data is passed along to the
> > child drivers (audio, vibra).
> >
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
> >
> > +config TWL4030_CODEC
> > +	bool "Support codec part of the TWL4030 family chips"
> 
> This seems like something that users shouldn't really have to worry
> about selecting explicitly - might it be better to have it selected by
> the drivers that use it instead?  It feels like it's an implementation
> detail of the driver.

Yes, first I had the TWL4030_CODEC selected in the sound/soc/codecs/Kconfig, but 
for some reason I have decided to add user selectable config option instead and 
use the depends on in the codecs Makefile.
I'll make the change as you suggested.


-- 
Péter
