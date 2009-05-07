Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbZEGUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbZEGUlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZEGUlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:41:08 -0400
Received: from mail.crca.org.au ([67.207.131.56]:41797 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZEGUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:41:04 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
 suspend with Intel HDA
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Takashi Iwai <tiwai@suse.de>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <s5hr5z12jn5.wl%tiwai@suse.de>
References: <20090420194659.GA11399@dose.home.local>
	 <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local>
	 <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local>
	 <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local>
	 <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61>
	 <20090506222753.GA6728@mac.home> <20090507072352.GA6513@mac.home>
	 <s5hy6t92nuz.wl%tiwai@suse.de> <1241697280.19600.203.camel@nigel-laptop>
	 <s5hr5z12jn5.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 08 May 2009 06:42:04 +1000
Message-Id: <1241728924.19600.208.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 14:16 +0200, Takashi Iwai wrote:
> At Thu, 07 May 2009 21:54:40 +1000,
> Nigel Cunningham wrote:
> > 
> > Hi.
> > 
> > On Thu, 2009-05-07 at 12:45 +0200, Takashi Iwai wrote:
> > > The problem is that BIOS on your machine sets this pin both for
> > > input and output.  Since it's set as input, the driver respects
> > > the BIOS setup and skips to override.
> > 
> > 'scuse the ignorance, but this makes me ask: Are pins logically
> > unrelated to jacks?
> 
> Yes, they are.
> 
> > I have a Dell M1530, and it has some jacks that can
> > work as either inputs or outputs. Under M$, when I plug something in, a
> > dialog box pops up asking me whether I connected a mic, line in or an
> > output jack (I forget the details). Sounds like Tino's problem is what
> > I'd expect from my BIOS. But I'm probably completely ignorant :)
> 
> The problem there is that the BIOS sets the current pin direction for
> both input and output, but you can't play and record at the same time
> on a jack.  It's not about the capability. 
> 
> BIOS is supposed to set all the pins properly ready for use, but it's
> not so on Mac.

Thanks! :)

Nigel

