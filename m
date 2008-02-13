Return-Path: <linux-kernel-owner+w=401wt.eu-S1765785AbYBMLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765785AbYBMLTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYBMLTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:19:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57267 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753978AbYBMLTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:19:10 -0500
Date: Wed, 13 Feb 2008 11:19:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-ID: <20080213111907.GC31617@rakim.wolfsonmicro.main>
Mail-Followup-To: Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20080212101738.GB21039@rakim.wolfsonmicro.main> <1202811705-2303-1-git-send-email-broonie@opensource.wolfsonmicro.com> <fot8b9$b6c$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fot8b9$b6c$1@ger.gmane.org>
X-Cookie: HUGH BEAUMONT died in 1982!!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:58:50PM +0000, Dmitry Baryshkov wrote:

> You used platform_device_register, but should be using platform_device_add,
> otherwise you get barfs with 2.6.25-rc1 (device is initialized twice). Also

Thanks for that.  I feel like I should knock up a patch to clarify the
platform API documentation here.

> as <sound/driver.h> got deprecated there is no point including it.

Indeed - this is bit rot due to the age of the driver.  Hopefully it
will make it into at least 2.6.26.

BTW, could you please keep at least me in the CC list when discussing
these patches?  It's easy to miss things on the lists and they're one of
the first things I stop reading when I'm busy.
