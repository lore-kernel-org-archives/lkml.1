Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZLVMen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZLVMen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZLVMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:34:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515AbZLVMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:34:42 -0500
Date: Tue, 22 Dec 2009 12:34:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <dvrabel@arcom.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Paul Mundt <lethal@linux-sh.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/7] ASoC: sh: FSI:: don't check platform_get_irq's
	return value against zero
Message-ID: <20091222123440.GB19056@opensource.wolfsonmicro.com>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de> <1260979809-24811-7-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260979809-24811-7-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:10:09PM +0100, Uwe Kleine-König wrote:
> platform_get_irq returns -ENXIO on failure, so !irq was probably
> always true.  Better use (int)irq <= 0.  Note that a return value of
> zero is still handled as error even though this could mean irq0.
> 
> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied, thanks.
