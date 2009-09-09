Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZIIQgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZIIQgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZIIQgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:36:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52748 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZIIQgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:36:06 -0400
Date: Wed, 9 Sep 2009 17:36:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's in sound git tree for 2.6.32
Message-ID: <20090909163608.GA28313@sirena.org.uk>
References: <s5hljkoyu5s.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hljkoyu5s.wl%tiwai@suse.de>
X-Cookie: Read terms and conditions.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 06:11:59PM +0200, Takashi Iwai wrote:

> ASoC has really many changes, including the update of DaVinci, imx,
> blackfin and other machine drivers together with tons of new codecs.
> Also the common register cache helper is there.

The most noticable changes in the ASoC core for this release are:

 - Redone power sequencing code, giving shorter power sequences which
   should reduce the effect of any artifacts that exist.

 - Reporting of power management decisions via debugfs, enabling much
   easier diagnosis of path setup problems.

 - Beginning of work to factor out the register access and caching code
   from the individual CODEC drivers into a shared file.  This needs to
   be rolled out over more CODEC drivers.
