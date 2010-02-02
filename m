Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0BBLI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:08:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53709 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754865Ab0BBLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:08:26 -0500
Date: Tue, 2 Feb 2010 11:08:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 10/10] sound/soc/blackfin: Fix continuation line formats
Message-ID: <20100202110824.GF6566@rakim.wolfsonmicro.main>
References: <cover.1264967493.git.joe@perches.com>
 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
 <20100201144745.GC26011@rakim.wolfsonmicro.main>
 <1265044080.25140.266.camel@Joe-Laptop.home>
 <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
X-Cookie: Nothing is but what is not.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:13:04PM -0500, Mike Frysinger wrote:
> On Mon, Feb 1, 2010 at 12:08, Joe Perches wrote:

> > There are a few false positives and probably a few missing using

> >        grep -rP --include=*.[ch] '".*\\$' * | \
> >        awk '{ if ((gsub("\"", "\"") % 2) == 1) print $0; }'

> > Most of the uses are __asm__ __volatile__ which could be
> > considered unsightly but don't impact logging messages.

> > The rest could/should be fixed.

My point was that it'd be good to also check for just regular use of
continuations in code other than macro definitions.  These are just a
style nit but if there's a script that filters out false positives from
the macros that'd be handy...

> the Blackfin alsa fixes all look good to me, thanks

Running "grep ' \\$' sound/soc/blackfin/*.[ch]" suggests that there's
still some of the continuations I mentioned above in there (plus a lot
of false positives from macros).
