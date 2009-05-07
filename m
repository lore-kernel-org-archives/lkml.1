Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZEGU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZEGU4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZEGU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:56:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:24898 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZEGU4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Nh+EE1jt8hCVuBDF7VtF0+CG+hn0uQw3z8+WxW9u9fTxpZ0nQSE3rh7PKqalFfrFlL
         jTUDnLAbDLIXS3leRUanm0F7YhIREmuAQk3qY7dTAqZXDnN4EP2WK07A7GtNsESa5z/v
         VFWTfD3V5+FBVXQb6GRfgmxtH1y85TzeaJW6A=
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
 suspend with Intel HDA
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: ncunningham-lkml@crca.org.au
Cc: Takashi Iwai <tiwai@suse.de>, Tino Keitel <tino.keitel@gmx.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <1241728924.19600.208.camel@nigel-laptop>
References: <20090420194659.GA11399@dose.home.local>
	 <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local>
	 <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local>
	 <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local>
	 <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61>
	 <20090506222753.GA6728@mac.home> <20090507072352.GA6513@mac.home>
	 <s5hy6t92nuz.wl%tiwai@suse.de> <1241697280.19600.203.camel@nigel-laptop>
	 <s5hr5z12jn5.wl%tiwai@suse.de>  <1241728924.19600.208.camel@nigel-laptop>
Content-Type: text/plain
Date: Thu, 07 May 2009 13:56:05 -0700
Message-Id: <1241729765.13392.2.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 06:42 +1000, Nigel Cunningham wrote:
> Hi.
> 
> On Thu, 2009-05-07 at 14:16 +0200, Takashi Iwai wrote:
> > At Thu, 07 May 2009 21:54:40 +1000,
> > Nigel Cunningham wrote:
> > > 
> > > Hi.
> > > 
> > > On Thu, 2009-05-07 at 12:45 +0200, Takashi Iwai wrote:
> > > > The problem is that BIOS on your machine sets this pin both for
> > > > input and output.  Since it's set as input, the driver respects
> > > > the BIOS setup and skips to override.
> > > 
> > > 'scuse the ignorance, but this makes me ask: Are pins logically
> > > unrelated to jacks?
> > 
> > Yes, they are.
> > 
> > > I have a Dell M1530, and it has some jacks that can
> > > work as either inputs or outputs. Under M$, when I plug something in, a
> > > dialog box pops up asking me whether I connected a mic, line in or an
> > > output jack (I forget the details). Sounds like Tino's problem is what
> > > I'd expect from my BIOS. But I'm probably completely ignorant :)
> > 
> > The problem there is that the BIOS sets the current pin direction for
> > both input and output, but you can't play and record at the same time
> > on a jack.  It's not about the capability. 
> > 
> > BIOS is supposed to set all the pins properly ready for use, but it's
> > not so on Mac.
> 
> Thanks! :)
> 
> Nigel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

One thing that they did(which is nice)
is finally, if you mute or turn down the master
volume, once rebooting you don't have
that BONG or introduction noise.

Justin P. Mattock

