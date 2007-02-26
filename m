Return-Path: <linux-kernel-owner+w=401wt.eu-S1161015AbXBZUbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015AbXBZUbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXBZUbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:31:00 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:60863 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXBZUa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:30:59 -0500
Date: Mon, 26 Feb 2007 21:32:23 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070226203223.GA161@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD> <1172510654.7101.11.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172510654.7101.11.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> On Mon, 2007-02-26 at 18:13 +0100, DervishD wrote:
> > > Try fbset -a -vyres 600 first and let us know of the result.
> > 
> > After doing this, I no longer can garble the display (before, just a
> > "ls -lR /" was enough to do it, in fact, any big output garbled the
> > display). The only problem with this solution is that the scroll
> > speed has decreased a bit. In fact, the scroll speed is affected by
> > the vyres parameter a lot! The highter the vyres, the faster the
> > scroll, and I cannot reproduce the problem anymore after changing it
> > once!
> 
> Display panning is what makes scrolling fast which is the default
> scroll method if vyres > yres.  Unfortunately, tdfxfb occasionally
> have problems with this method, the higher the vyres, the greater the
> likelihood of screen corruption.

    Then I'll try with 4096 and will diminish the number until the
display is stable.

> That's why tdfxb limits the vyres to a maximum of 4096. As to why the
> problem disappeared just by changing this parameter, that I too don't
> know.

    Probably setting it back to 4096 will make the problem reappear.
Right now I cannot test, but I'll make some experiments.

    Thanks a lot!

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
