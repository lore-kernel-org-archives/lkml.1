Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZGTM0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZGTM0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZGTM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:26:23 -0400
Received: from relay3.sgi.com ([192.48.156.57]:46778 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752421AbZGTM0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:26:23 -0400
Date: Mon, 20 Jul 2009 07:26:23 -0500
From: Robin Holt <holt@sgi.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Commit 1e137f92 broke my Vaio VGN-FE550G's hda_intel driver.
Message-ID: <20090720122623.GL6876@sgi.com>
References: <20090719140102.GI6876@sgi.com> <s5hy6qkk6am.wl%tiwai@suse.de> <20090719225538.GK6876@sgi.com> <s5heisbc2rk.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5heisbc2rk.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:00:31AM +0200, Takashi Iwai wrote:
> At Sun, 19 Jul 2009 17:55:38 -0500,
> Robin Holt wrote:
> > 
> > > What about to pass model=vaio?  Doesn't it work?
> > 
> > That didn't change the behavior.
> > 
> > > In anyways, please run alsa-info.sh with --no-upload option, and attach
> > > the generated file.
> > 
> > Here is the output from alsa-info.sh.  This was from the module load without
> > the model=vaio.  Below, (search for ---Robin---) is the output from alsa-info.sh
> > with model=vaio.
> 
> Thanks.  This look really like a bug.  The pin definition was wrongly
> placed.  It should have been before the pin overrides.
> 
> Could you try the patch below?  With the patch, the driver would work
> even without any model option.

Patch worked perfectly.

Acked-by: Robin Holt <holt@sgi.com>

Thanks,
Robin
