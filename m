Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZGOJOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZGOJOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZGOJOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:14:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41590 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395AbZGOJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:14:10 -0400
Date: Wed, 15 Jul 2009 10:14:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sound/soc/codecs/wm9081.c compiler warning
Message-ID: <20090715091409.GD8689@rakim.wolfsonmicro.main>
References: <1247639434.2437.14.camel@ht.satnam>
 <s5heisixqdk.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5heisixqdk.wl%tiwai@suse.de>
X-Cookie: Use other side for additional listings.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:11:19AM +0200, Takashi Iwai wrote:
> At Wed, 15 Jul 2009 12:00:34 +0530,
> Jaswinder Singh Rajput wrote:

> > I am getting this compiler warning in linus tree:

> >   CC [M]  sound/soc/codecs/wm9081.o
> > sound/soc/codecs/wm9081.c: In function ‘configure_clock’:
> > sound/soc/codecs/wm9081.c:674: warning: ‘new_sysclk’ may be used uninitialized in this function

> > This fixes the warning in my case, hope this will be helpful :

> I think your fix is OK, but I let it to Mark :)

I'm just looking at this at the minute.  I'm trying to decide if it
should take that approach or error out if it can't find a configuration.

Again, I'm not seeing the warning itself - compiler versions would be
useful in warning reports (particularly for control flow analysis stuff
like this).
