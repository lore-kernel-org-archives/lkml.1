Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZGJTTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZGJTTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZGJTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:19:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60469 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZGJTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:19:35 -0400
Date: Fri, 10 Jul 2009 20:19:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rongrong Cao <rrcao@ambarella.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Message-ID: <20090710191925.GA5916@sirena.org.uk>
References: <90B0CE4312136749B97EBEAF5764F87403C8F77A@ambarella-ex.ambarella.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90B0CE4312136749B97EBEAF5764F87403C8F77A@ambarella-ex.ambarella.net>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH for-2.6.32] sound dapm: fix checking for external
 widgets bug
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:11:46PM -0700, Rongrong Cao wrote:
> From: Rongrong Cao rrcao@ambarella.com

> This patch is based on for-2.6.32
> In SOC DAPM layer of SOUND subsystem, when add signal route (in the function snd_soc_dapm_add_route() ), 
> the original code has wrong logic when dapm layer check each widget whether an external one.

This still doesn't apply.  It looks like your MUA is corrupting the
patch - it's MIME encoded everything and replaced all the tabs with
spaces which is causing all the patch application programs I have to get
confused.  Documentation/email-clients.txt has some suggestions on how
to configure various MUAs to send patches cleanly.  Personally I always
use git send-email.  You probably also want to have a look at the
instructions in Documentation/SubmittingPatches with regard to the
formatting of your patch - the main thing being that the Signed-off-by
should go before the patch content.

In any case, I've manually applied the patch so no need to resubmit it.

I also notice that you've CCed trivial@kernel.org.  Please don't do that
except for things that can't possibly cause bugs - a change like this
doesn't really qualify since while the code clearly looks buggy it's
always possible that the code is just obscure.
