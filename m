Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXJGXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXJGXVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXJGXVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:21:05 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:57265 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbXJGXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:21:04 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Date: Mon, 8 Oct 2007 00:20:59 +0100
User-Agent: KMail/1.9.7
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <200710072340.40828.alistair@devzero.co.uk> <47096752.2070107@keyaccess.nl>
In-Reply-To: <47096752.2070107@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710080020.59742.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 00:10:10 Rene Herman wrote:
> On 10/08/2007 12:40 AM, Alistair John Strachan wrote:
> > Splash screens are clearly cosmetic, and it's kind of shameful (imo) that
> > important messages explaining real problems are obscured from view by
> > functionless splash screens.
>
> They're not functionless. You (and I) might not care for the function, but
> their function is providing a "slick" bootup. That's why so many if not
> basically all distributions of recent origin use them. Go ask Ubuntu for
> example.
>
> > Personally, I think muddying the vga colour argument with splash screen
> > stuff is bogus, they're very functionally separable ideas. A coloured
> > oops seems to be a good way of telling novice users what information is
> > relevant to their bug report.
>
> But when they're hidden by a splash screen, you don't see them any better
> when they're red than when they're white. Splash screens were not mentioned
> as any sort of alternative, their prevalence was mentioned as indication
> that VGA console is only ever getting less important.

Obviously true, but that's not a reason to bar enhancements to the VGA 
console. Right now, there's no sane way to have a splash screen in userspace 
handle an oops, so people looking to reproduce and detect the root of a 
problem will inevitably fall back to VGA (or vesa, presumably), where colour 
might be useful.

I recall seeing a distro kernel oops early in boot, where the palette had been 
corrupted by the splash so the oops wasn't readable. That's bad, right?

Don't get me wrong, I don't care for the feature much, I just don't 
think "splash screens are defacto" is a reason to shy away from a feature 
that could be useful for novices reporting kernel bugs. These people are 
probably inbetween those that must have a shiny splash and those that fix the 
kernel bugs.

Of course, what Alan said elsewhere about breaking things that work is a good 
reason to not add the feature, or at least make it only happen on a real 
display.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
