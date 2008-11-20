Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYKTS4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYKTS4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYKTS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:56:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1877 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbYKTS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:56:27 -0500
Date: Thu, 20 Nov 2008 18:56:16 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: "Richard A. Holden III" <aciddeath@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Message-ID: <20081120185616.GA8761@sirena.org.uk>
Mail-Followup-To: "Richard A. Holden III" <aciddeath@gmail.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com> <1227204203-32112-2-git-send-email-aciddeath@gmail.com> <1227204203-32112-3-git-send-email-aciddeath@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227204203-32112-3-git-send-email-aciddeath@gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Remove unused variable from tlv320aic23 codec
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 11:03:23AM -0700, Richard A. Holden III wrote:

> Remove codec var from tlv320aic23_set_dai_sysclk, it is assigned to
> but never read.

This does not apply - it looks like you've generated it against code
from before commit 26df91c3 (ASoC: TLV320AIC23B Support more sample
rates) from 5th November which rewrote all this code.
