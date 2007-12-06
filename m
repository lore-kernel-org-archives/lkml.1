Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbXLFUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbXLFUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLFUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:12:07 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:44750 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXLFUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MV65uivtcaQCs4BbqpFgUixPVp7XTVCkF+mXa3loIKS6htXiMoJiBGFnyAmOClBTT15rSp2TFeYpCF8mR5NXPliyrcpiYsD5r3HzqVqCkP6t5CImav9827hsg/bRDbbJcfRfbvF/dl1M22TectJueiPKtMppwtxuFzAqQ126KKM=
Message-ID: <3efb10970712061212i7198f53eo5a8d8774465b3dde@mail.gmail.com>
Date: Thu, 6 Dec 2007 21:12:05 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>,
       "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
In-Reply-To: <20071206200542.GE480@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <20071206200542.GE480@traven>
X-Google-Sender-Auth: 4e23efb35b14e8d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthias,

Which do you have exactly on your list? (good to know, it prevents
double work...)

Remy

2007/12/6, Matthias Kaehlcke <matthias.kaehlcke@gmail.com>:
> El Thu, Dec 06, 2007 at 08:34:06AM -0800 Daniel Walker ha dit:
>
> > On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > >
> > > > The port_mutex is actually a semaphore, so easily converted to a
> > > > struct mutex.
> > > >
> > > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > >
> > > Acked-by: Ingo Molnar <mingo@elte.hu>
> > >
> > > cool. How far away are we from being able to remove all the semaphore
> > > code? :-)
> >
> > I wish my 7 patches made a dent, but it's hasn't done much. ;(
> >
> > I would guess at least a week just to mop up the relatively easy ones..
> > I've got 12 in my queue, and there still ~50 hopefully trivial ones
> > still to be looked at.. Then another ~30 more difficult ones (that use
> > init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..
>
> I've also more patches of this type on my list, though i work in a
> slower pace
>
> --
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
>
>              You must have a plan. If you don't have a plan,
>                you'll become part of somebody else's plan
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
>
