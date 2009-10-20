Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbZJTKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbZJTKDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZJTKDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:03:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41904 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750878AbZJTKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:03:31 -0400
Date: Tue, 20 Oct 2009 11:03:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, sameo@linux.intel.com, tony@atomide.com
Subject: Re: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child
	to the core
Message-ID: <20091020100334.GA28592@opensource.wolfsonmicro.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:42:17PM +0300, Peter Ujfalusi wrote:
> New MFD child to twl4030 MFD device.
> This MFD device will be used by the drivers, which needs resources
> from the twl4030 codec like audio and vibra.

> The platform specific configuration data is passed along to the
> child drivers (audio, vibra).

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

> +config TWL4030_CODEC
> +	bool "Support codec part of the TWL4030 family chips"

This seems like something that users shouldn't really have to worry
about selecting explicitly - might it be better to have it selected by
the drivers that use it instead?  It feels like it's an implementation
detail of the driver.
