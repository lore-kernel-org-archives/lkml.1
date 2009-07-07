Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZGGSkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZGGSkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 14:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZGGSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 14:39:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55014 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZGGSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 14:39:58 -0400
Date: Tue, 7 Jul 2009 19:39:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rongrong Cao <rrcao@ambarella.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Message-ID: <20090707183948.GA6681@sirena.org.uk>
References: <90B0CE4312136749B97EBEAF5764F87403C8F2D3@ambarella-ex.ambarella.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90B0CE4312136749B97EBEAF5764F87403C8F2D3@ambarella-ex.ambarella.net>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound dapm: fix check for external widgets bug (based
 on linux-2.6.30.1)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 05:55:27AM -0700, Rongrong Cao wrote:

> This patch is based on linux-2.6.30.1
> In SOC DAPM layer of SOUND subsystem, when add signal route (in the function snd_soc_dapm_add_route() ), 
> the original code has wrong logic when dapm layer check each widget whether an external one.

This looks like it's probably a good fix but doesn't apply against
current ASoC since there have been some changes in this area.  The
latest ASoC code can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.32

Could you please regenerate (and ideally retest too) against that?

It may be useful to take a look at Documentation/SubmittingPatches for
details on how patches should normally be submitted.
