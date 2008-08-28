Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYH1Lp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYH1Lp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYH1Lo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:44:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12922 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYH1Lo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:44:58 -0400
Date: Thu, 28 Aug 2008 13:44:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
       Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/4] ASOC codec: add support for SSM2602
 audio codec in ALSA SoC framework
Message-ID: <20080828134439.0f55e2e4@hyperion.delvare>
In-Reply-To: <20080828100615.GA11132@sirena.org.uk>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	<1219829968-6431-3-git-send-email-cooloney@kernel.org>
	<20080827105456.GA10834@sirena.org.uk>
	<386072610808272255o7ef18860u29e10727e6e11a11@mail.gmail.com>
	<20080828100615.GA11132@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Mark,

On Thu, 28 Aug 2008 11:06:18 +0100, Mark Brown wrote:
> On Thu, Aug 28, 2008 at 01:55:33PM +0800, Bryan Wu wrote:
> > Yes, I will fix this issue by running checkpatch.pl. And for other API
> > conflicts and I2C interface upgrading stuffs,
> > I will leave them to Cliff.
> 
> OK.  Jean might be willing to do the I2C API conversion for you (I've
> CCed him in).

Sure, I can help with that if needed. OTOH, I've posted patches
converting 2 drivers already [1] [2], and apparently all the codec
drivers follow the same model so it shouldn't be too difficult for
driver authors to do the same on their code. But anyway I'll convert
the remaining drivers as my time permits. The plan is to have
everything converted for kernel 2.6.28 (at which point the old I2C API
will be deprecated.)

[1] http://mailman.alsa-project.org/pipermail/alsa-devel/2008-August/010198.html
[2] http://mailman.alsa-project.org/pipermail/alsa-devel/2008-August/010199.html

-- 
Jean Delvare
