Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZKBSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZKBSA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZKBSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:00:25 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54464 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZKBSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BFMNowoLkKXXz2FgPqo36s2iet66rpfPfPBP9QsJe68Es+Yyu0y/VUuLhEZWYqbGmD
         IZvQb6CDAttf8YXlAd+EP8IRzac1Px4ySN7WgzPyLifQ0xXufnab4GpJozsVuGPMckqw
         sjb202jK2AB4zeIN1mVMhIUyXMQkvQY2g3mBU=
Date: Mon, 2 Nov 2009 10:00:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: ALPS touchpad with 4 directions button doesnt work as intended
Message-ID: <20091102180024.GA3437@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop> <20091102053834.GA3354@core.coreip.homeip.net> <1257182426.3682.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257182426.3682.2.camel@maxim-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 07:20:26PM +0200, Maxim Levitsky wrote:
> On Sun, 2009-11-01 at 21:38 -0800, Dmitry Torokhov wrote: 
> > Hi Maxim,
> > 
> > On Sat, Oct 31, 2009 at 04:10:18AM +0200, Maxim Levitsky wrote:
> > > I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
> > > usual left/right, and middle button that can be pressed in 4 directions.
> > > Up/down direction work fine, but left/right doesn't. This means that
> > > left direction  produces middle button click, and right direction
> > > doesn't work at all.
> > > I took a look at source, and I see that driver doesn't even know about
> > > such configuration.
> > > 
> > > Now I am sure its very easy to figure out what is send when no working
> > > button is pressed, but I am a bit confused what BTN_* event to assign to
> > > it, so it will work as horizontal scroll as intended.
> > > And unassign middle button from other direction....
> > > 
> > 
> > Synaptics driver maps multi-button to BTN_0...BTN_8 and it looks like
> > synaptics X driver maps teh 4-button case by default to
> > up/down/left/right scroll so I'd map ALPS the same.
> > 
> Thanks!
> 
> One question, should I expect some resistance because the button won't
> work as middle button by default? (I am sure that in X its easy remap it
> back)
> 

I am pretty sure these kind of buttons allow 5 distinct presses - left,
right, up, down and "straight" (which may be reported either with
distinct packet or by reporting both up/down or left/right presses) so
you don't have to loose the middle button. This is a speculation
though...

-- 
Dmitry
