Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZDRWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZDRWN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 18:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZDRWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 18:13:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:65394 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZDRWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 18:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QKJ6zVV0VoRno+QZcjKlbT/wTZ1PXQzQZVi6G9+IgZy+N2yugoQdU3icoFiJoi0inT
         ntGOH3fyMCc24i5SK41ByDwdbRID0y6ESg4v+xB5IyDc62KeV0BYMljVJ7az8zSSnMJ2
         o/VH20pLdSNaNt59gP7J0fEAJgtdXIDqS0AEc=
Date: Sat, 18 Apr 2009 15:13:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lukasz Stelmach <stlman@poczta.fm>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use multitouch touchpad events as buttons mousedev
Message-ID: <20090418221313.GB30524@dtor-d630.eng.vmware.com>
References: <49B46ADA.5060809@poczta.fm> <20090416021126.GE2413@dtor-d630.eng.vmware.com> <49EA1392.5060008@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EA1392.5060008@poczta.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 07:53:22PM +0200, Lukasz Stelmach wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dmitry Torokhov pisze:
> > Hi Lukasz,
> > 
> > On Mon, Mar 09, 2009 at 02:03:22AM +0100, Lukasz Stelmach wrote:
> >> Some touchpads can recognize multi-finger taps. They can be used as
> >> additional buttons (left and middle).
> >>
> > 
> > mousedev is a legacy interface and I don't think this change is needed
> > since evdev + Synaptics X driver combination works much better with
> > touchpads anyway.
> 
> That is true, however, I happen to use plain old virtual terminal with
> gpm which uses mousedev. Having that multitouch buttons is, I assure you,
> awesome.
> 

I see. In this case I suggest switching GPM to use evdev protocol. Since
I added what I cosider proper evdev support for GPM a few years ago it
should work OK without need to patch mousedev.

-- 
Dmitry
