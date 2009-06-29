Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZF2Qda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZF2Qda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbZF2QdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:33:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56336 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZF2QdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:33:21 -0400
Date: Mon, 29 Jun 2009 17:33:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ilya Petrov <ilya.muromec@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
Message-ID: <20090629163323.GI11855@sirena.org.uk>
References: <1246122592.3727.20.camel@brutus> <20090629094658.GE11855@sirena.org.uk> <800a98740906290927q5469f17fpcd74295e7ce40fb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800a98740906290927q5469f17fpcd74295e7ce40fb0@mail.gmail.com>
X-Cookie: Function reject.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:27:24PM +0300, Ilya Petrov wrote:
> 2009/6/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > Depending on the power management capabilities of the CODEC it may be
> > better to support at laest the headphone insert/removal via the audio
> > driver as a jack to allow automatic management of the power for the
> > relevant paths within the CODEC.

> we need to control this manually from userspace - for example, even with
> headphone plugged in ringtone should be played via speaker.

ALSA jacks are still visible to user space as input devices.  The
difference it will make here is that the kernel can autonomously control
power for paths where that makes sense.
