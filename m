Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYH1KGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYH1KGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYH1KG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:06:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4708 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYH1KG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:06:26 -0400
Date: Thu, 28 Aug 2008 11:06:18 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: perex@perex.cz, lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org
Subject: Re: [alsa-devel] [PATCH 2/4] ASOC codec: add support for SSM2602 audio codec in ALSA SoC framework
Message-ID: <20080828100615.GA11132@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, perex@perex.cz,
	lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	khali@linux-fr.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-3-git-send-email-cooloney@kernel.org> <20080827105456.GA10834@sirena.org.uk> <386072610808272255o7ef18860u29e10727e6e11a11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610808272255o7ef18860u29e10727e6e11a11@mail.gmail.com>
X-Cookie: To see you is to sympathize.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:55:33PM +0800, Bryan Wu wrote:
> On Wed, Aug 27, 2008 at 6:54 PM, Mark Brown <broonie@sirena.org.uk> wrote:

> > Current kernels have a Kconfig option SND_SOC_ALL_CODECS which should
> > have your codec added - this allows codec drivers to be built without
> > boards for test purposes.

> Is this option in alsa git tree or in the mainline? I fail to find it
> in upstream mainline.
> And do you mean I don't need to add SND_SOC_SSM2602 at all?

It's in ALSA git, queued for the 2.6.28 merge window.  See the
topic/asoc branch of:

        git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

for the current ASoC merge queue.  The other API changes will all be
queued there too.

There's quite a bit of churn in ASoC at the minute but additional API
changes will be taken care of by whoever does them once your driver is
merged so it should save you some work if you're able to get this in
soon.

> Yes, I will fix this issue by running checkpatch.pl. And for other API
> conflicts and I2C interface upgrading stuffs,
> I will leave them to Cliff.

OK.  Jean might be willing to do the I2C API conversion for you (I've
CCed him in).
