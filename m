Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZLNLiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZLNLiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZLNLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:38:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35039 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753049AbZLNLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:38:53 -0500
Date: Mon, 14 Dec 2009 11:38:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/9] sound/soc/codecs: Correct code taking the size of
 a pointer
Message-ID: <20091214113851.GD21066@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk>
X-Cookie: Too much is not enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 12:43:15PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(codec->reg_cache) is just the size of the pointer.  Elsewhere in the
> file, codec->reg_cache is used with sizeof(wm8900_reg_defaults), so the
> code is changed to do the same here.

Applied, thanks.
