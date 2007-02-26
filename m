Return-Path: <linux-kernel-owner+w=401wt.eu-S1030344AbXBZRMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344AbXBZRMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030345AbXBZRMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:12:15 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:62828 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030344AbXBZRMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:12:13 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 12:12:13 EST
Date: Mon, 26 Feb 2007 18:13:34 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070226171334.GB13496@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172503471.20842.14.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> On Mon, 2007-02-26 at 15:47 +0100, DervishD wrote:
> >     From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
> > test in 2.6.20.x because it doesn't compile, the infamous BDF negative
> > offset problem) garbles the display, leaving only a lot of thin lines,
> > just like sync was lost. The display can be repaired by switching to
> > another console, but this is annoying. This happens with a Voodoo 3
> > 3000, using 800x600x8@100 mode.
> 
> Try fbset -a -vyres 600 first and let us know of the result.

    After doing this, I no longer can garble the display (before, just a
"ls -lR /" was enough to do it, in fact, any big output garbled the
display). The only problem with this solution is that the scroll speed
has decreased a bit. In fact, the scroll speed is affected by the vyres
parameter a lot! The highter the vyres, the faster the scroll, and I
cannot reproduce the problem anymore after changing it once!

    I'm really confused :?

    Thanks a lot for the fix :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
