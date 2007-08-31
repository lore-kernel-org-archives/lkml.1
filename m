Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXHaP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXHaP0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXHaP0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:26:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:55344 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbXHaP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jsvaoBXfB2wnP1lA146WlVuU84v+LIHMLt2iqoyiQSPxFevjEGs53k7oAK6u0sl/F13jeFyXhFgsMlSHj3B7xR/5oe5gAbid3Y7Mn5os/YPk1bl98Liik7sBDicA7/VA02qhTuqRl69+L93LTCsh9+BLz4e4Tu/TmLKjs+4GR1U=
Message-ID: <d120d5000708310826q7ddf3514w55b3f4f0cca599ca@mail.gmail.com>
Date: Fri, 31 Aug 2007 11:26:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] input: Silence 'unused variable' warning in iforce joystick driver
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Vojtech Pavlik" <vojtech@ucw.cz>,
       "Johann Deneux" <johann.deneux@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
In-Reply-To: <200708310050.03786.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708310013.12347.jesper.juhl@gmail.com>
	 <alpine.LFD.0.999.0708310422200.31519@enigma.security.iitk.ac.in>
	 <200708310050.03786.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On 8/30/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 31/08/2007, Satyam Sharma <satyam@infradead.org> wrote:
> ...
> >
> > Hmm, would this not still give a warning when JOYSTICK_IFORCE_USB=y?
>
> Arrgh, I messed that one up real good...  Thank you for your keen eye Satyam :-)
>
>
> > [ I didn't know mixing code and declarations (not at top of statement
> >   block) was accepted style in the kernel ... ]
> >
> It's not the common case, but this is certainly not the only place in the kernel where we do it.
>
>
> > IMHO either you should at least wrap that case inside a {} of its
> > own (so that the int status; is at top of a statement block), or else,
>
> Yeah, I should...
>
> > preferably, just add "__maybe_unused" to the first declaration that you
> > removed just now.
> >
>
> Here's an updated patch that actually works as intended.
>

I had a similar patch from Andrew Morton in my queue and it just got
merged. There should be no warning anymore.

-- 
Dmitry
