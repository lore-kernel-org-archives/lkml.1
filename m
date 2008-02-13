Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbYBMLcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbYBMLcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYBMLcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:32:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:22688 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbYBMLcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:32:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Oqjxc9MX6O6Adb1jpD0zNUE7nTQ2KC7JkrVEePnwc1BIAao4H34zpJKYI5TaAXkLV4FilRSuoC6FinzZlHWNCc3Tga6kZlM7w9hUP/fWABIoIla4TEzQZ9gQjwHvIqPoDm09HISfmU8d91Vwhh14oJySihT34DTTn2yXDYRE840=
Message-ID: <bc64b4640802130332h50415be0s413430f917dfe07d@mail.gmail.com>
Date: Wed, 13 Feb 2008 14:32:27 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
In-Reply-To: <20080213111907.GC31617@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080212101738.GB21039@rakim.wolfsonmicro.main>
	 <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <fot8b9$b6c$1@ger.gmane.org>
	 <20080213111907.GC31617@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/2/13, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Feb 12, 2008 at 10:58:50PM +0000, Dmitry Baryshkov wrote:
>
> > You used platform_device_register, but should be using platform_device_add,
> > otherwise you get barfs with 2.6.25-rc1 (device is initialized twice). Also
>
> Thanks for that.  I feel like I should knock up a patch to clarify the
> platform API documentation here.

:)

> > as <sound/driver.h> got deprecated there is no point including it.
>
> Indeed - this is bit rot due to the age of the driver.  Hopefully it
> will make it into at least 2.6.26.

Hope so too. It  should be in the mainline since long ago.

> BTW, could you please keep at least me in the CC list when discussing
> these patches?  It's easy to miss things on the lists and they're one of
> the first things I stop reading when I'm busy.

Sorry. I often reply to the patchserie via gmane and it doesn't honour
non-ml addresses.

-- 
With best wishes
Dmitry
