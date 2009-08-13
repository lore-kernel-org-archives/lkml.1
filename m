Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbZHMUOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbZHMUOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZHMUOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:14:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbZHMUN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:13:58 -0400
Date: Thu, 13 Aug 2009 13:12:22 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 27/28] ALSA: hda - Add missing vmaster initialization
 for ALC269
Message-ID: <20090813201222.GA22916@suse.de>
References: <20090813194021.446758568@mini.kroah.org>
 <20090813194339.809516126@mini.kroah.org>
 <alpine.LFD.2.01.0908131258420.28882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908131258420.28882@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:59:05PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 13 Aug 2009, Greg KH wrote:
> > 
> > From: Takashi Iwai <tiwai@suse.de>
> > 
> > commit 100d5eb36ba20dc0b99a17ea2b9800c567bfc3d1 upstream.
> > 
> > Without the initialization of vmaster NID, the dB information got
> > confused for ALC269 codec.
> > 
> > Reference: Novell bnc#527361
> > 	https://bugzilla.novell.com/show_bug.cgi?id=527361
> > 
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  sound/pci/hda/patch_realtek.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/sound/pci/hda/patch_realtek.c
> > +++ b/sound/pci/hda/patch_realtek.c
> > @@ -13767,6 +13767,8 @@ static int patch_alc861vd(struct hda_cod
> >  
> >  	spec->vmaster_nid = 0x02;
> >  
> > +	spec->vmaster_nid = 0x02;
> > +
> >  	codec->patch_ops = alc_patch_ops;
> 
> You seem to have already applied this one earlier ;)

Heh, good catch, I've now removed this one from the queue.

thanks for the review,

greg k-h
