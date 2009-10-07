Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZJGMHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZJGMHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZJGMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:07:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44436 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758841AbZJGMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:07:22 -0400
Date: Wed, 7 Oct 2009 13:06:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com
Subject: Re: spitz: add gpio button support (AK_INT and remote control
 description)
Message-ID: <20091007120643.GA17069@rakim.wolfsonmicro.main>
References: <20091006074635.GA2775@ucw.cz>
 <1254829732.3546.35.camel@utx.utx.cz>
 <20091007085806.GB28807@elf.ucw.cz>
 <1254914991.4213.80.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254914991.4213.80.camel@hammer.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 01:29:51PM +0200, Stanislav Brabec wrote:

> SW_REMOTE_INSERT should be recognized by the Jack abstraction layer
> (sound/core/jack.c).

It's the other way around - the jack layer reports jacks for ALSA cards.
Also, for spitz you'd probably want to be using the ASoC wrapper layer.

> Well, I am thinking about defining extra values for resistors, that can
> make stuff even more useful at cost of need of non-standard wiring on
> fourth ring of the audio jack. It can generate SW_MICROPHONE_INSERT,
> SW_LINEOUT_INSERT, and not yet defined SW_HEADESET_INSERT and
> SW_LINEIN_INSERT (which would require hardware mod inside Zaurus for
> stereo line-in).

Headset should be represented by reporting headphone plus microphone on
one jack simultaneously.
