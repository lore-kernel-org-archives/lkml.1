Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbYBVSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbYBVSbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbYBVSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:31:48 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33327 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbYBVSbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:31:47 -0500
Date: Fri, 22 Feb 2008 19:31:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 14/16] [ALSA] caiaq - fix section mismatch warning
Message-ID: <20080222183156.GD6434@uranus.ravnborg.org>
References: <s5hoda8yjza.wl%tiwai@suse.de> <s5h3arkyjco.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3arkyjco.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi.


On Fri, Feb 22, 2008 at 06:46:47PM +0100, Takashi Iwai wrote:
> Fix following warning:
> WARNING: vmlinux.o(.text+0x11ec01a): Section mismatch in reference from the function setup_card() to the function .devinit.text:snd_usb_caiaq_control_init()
> 
> setup_card() are only used by init_card().
> init_card() are only used by snd_probe()
> snd_probe() are used for the .probe parameter in usb_driver.probe
> 
> Annotate them all __devinit to fix the warning.
> 
> From: Sam Ravnborg <sam@ravnborg.org>

git will not pick up me as author for this patch unless
you place the From: at the _first_ line in the commmit.

Nothing to worry for this simple patch - just so you know in the future.

	Sam
