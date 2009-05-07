Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZEGM7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZEGM7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZEGM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:59:34 -0400
Received: from eazy.amigager.de ([213.239.192.238]:55837 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZEGM7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:59:34 -0400
Date: Thu, 7 May 2009 14:59:33 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090507125933.GA4100@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local> <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61> <20090506222753.GA6728@mac.home> <20090507072352.GA6513@mac.home> <s5hy6t92nuz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy6t92nuz.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:45:08 +0200, Takashi Iwai wrote:

[...]

> Could you try the patch below instead?

Thanks, I'll try the patch ASAP.

> The problem is that BIOS on your machine sets this pin both for
> input and output.  Since it's set as input, the driver respects

In theory, the hardware jack can be used for input _and_ output. I
don't know if this is connected to the issue, though.

Regards,
Tino
