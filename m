Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0BAOrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:47:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53771 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754856Ab0BAOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:47:48 -0500
Date: Mon, 1 Feb 2010 14:47:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 10/10] sound/soc/blackfin: Fix continuation line formats
Message-ID: <20100201144745.GC26011@rakim.wolfsonmicro.main>
References: <cover.1264967493.git.joe@perches.com>
 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
X-Cookie: Minimum charge for booths.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 12:02:12PM -0800, Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Gah, I thought I'd caught most of these when reviewing.  If you're using
a script to pick this stuff up it'd be worth checking for extraneous
continuations in the middle of code - outside of macros there's little
call for it.

Applied, thanks.
