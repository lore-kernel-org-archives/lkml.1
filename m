Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZKBWQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZKBWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbZKBWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:16:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50325 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZKBWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L2TNtWYCqqsiKM8CImcg8HZZ6Fv2Lkavs+JB0FfBsRlzfYduXabTAj54u/ZZ9daHA+
         Oe7rS3mygJa9hN2IWjr4R3m3VyGs5PmdPy7Ul7E8HSrnKWJqtLvWliAPzjfCvPDvKplg
         p7xT+NbsBdTIEbbehux5XQCwjK1pcyuPLBMqQ=
Subject: Re: ALPS touchpad with 4 directions button doesnt work as intended
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1257199967.3164.8.camel@localhost.localdomain>
References: <1256955018.9681.23.camel@maxim-laptop>
	 <20091102053834.GA3354@core.coreip.homeip.net>
	 <1257182426.3682.2.camel@maxim-laptop>
	 <20091102180024.GA3437@core.coreip.homeip.net>
	 <1257199967.3164.8.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 00:16:28 +0200
Message-ID: <1257200188.3164.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 00:12 +0200, Maxim Levitsky wrote:
> On Mon, 2009-11-02 at 10:00 -0800, Dmitry Torokhov wrote:
> > On Mon, Nov 02, 2009 at 07:20:26PM +0200, Maxim Levitsky wrote:
> > > On Sun, 2009-11-01 at 21:38 -0800, Dmitry Torokhov wrote: 
> > > > Hi Maxim,
> > > > 
> > > > On Sat, Oct 31, 2009 at 04:10:18AM +0200, Maxim Levitsky wrote:
> > > > > I have a acer 5720G laptop, and its touchpad (ALPS) has three buttons,
> > > > > usual left/right, and middle button that can be pressed in 4 directions.
> > > > > Up/down direction work fine, but left/right doesn't. This means that
> > > > > left direction  produces middle button click, and right direction
> > > > > doesn't work at all.
> > > > > I took a look at source, and I see that driver doesn't even know about
> > > > > such configuration.
> > > > > 
> > > > > Now I am sure its very easy to figure out what is send when no working
> > > > > button is pressed, but I am a bit confused what BTN_* event to assign to
> > > > > it, so it will work as horizontal scroll as intended.
> > > > > And unassign middle button from other direction....
> > > > > 
> > > > 
> > > > Synaptics driver maps multi-button to BTN_0...BTN_8 and it looks like
> > > > synaptics X driver maps teh 4-button case by default to
> > > > up/down/left/right scroll so I'd map ALPS the same.
> > > > 
> > > Thanks!
> > > 
> > > One question, should I expect some resistance because the button won't
> > > work as middle button by default? (I am sure that in X its easy remap it
> > > back)
> > > 
> > 
> > I am pretty sure these kind of buttons allow 5 distinct presses - left,
> > right, up, down and "straight" (which may be reported either with
> > distinct packet or by reporting both up/down or left/right presses) so
> > you don't have to loose the middle button. This is a speculation
> > though...
> > 
> 
> Mine doesn't unfortunately, this is if I press it 'straight' I both feel
> physicaly 4 different presses and it reports currently, 'back button'
> 'forward button' and 'middle button' as I press it.
> 
> It is possible to implement emulation, but I think that pressing it
> straight might also put some stress and damage it in long run.
> 
> 
> I think that pressing left+right buttons will be enough for the
> replacement. If not, xmodmap can be used to map each of the 4 buttons
> (or all of them to middle one)
> 
> 
> Best regards,
> 	Maxim Levitsky
> 


Sorry,  forgot to CC lkml...



