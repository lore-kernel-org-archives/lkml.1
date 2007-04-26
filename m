Return-Path: <linux-kernel-owner+w=401wt.eu-S1031288AbXDZQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031288AbXDZQCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXDZQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:02:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:35240 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbXDZQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kcraq3mrWUnLWpL5ySUQcBI4mJlQcunegtmtwIqV8WLrJl743Vhbda45ISSRXaX1F3100dGcoIFv98JwcnYjYnI7f8r1EtBgfl2/jvlA7XQPyXkhdz1l9I9jx6aaLK4fJZwe4EnQerbHOXW5/7TnClFCLGBSpA46TPofRBRkPNg=
Message-ID: <d120d5000704260902h7950b30bi7a5a604c16f23421@mail.gmail.com>
Date: Thu, 26 Apr 2007 12:02:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: "johann deneux" <johann.deneux@gmail.com>, linux-kernel@vger.kernel.org,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <4af2d03a0704220557u5d6368a2t13878b73bf9dbe64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz> <462688AB.4060707@gmail.com>
	 <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
	 <200704190058.11625.dtor@insightbb.com> <46278CDD.2000007@gmail.com>
	 <d120d5000704190902o60aa4b19y77728585e22b2e84@mail.gmail.com>
	 <4af2d03a0704220557u5d6368a2t13878b73bf9dbe64@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 4/19/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > On 4/19/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > > Dmitry Torokhov napsal(a):
> > > > If we are interested in using FF API we need to come up with a way
> > > > to express this effect without exposing implementation details of
> > > > one particular device.
> > >
> > > Still, torques are better named raw/motor values, which goes to the device
> > > and I'm sceptic about inventing something class-better than this.
> > >
> >
> > Well, I guess we need to make a decision whether moving this kind of
> > devices into a force feedback layer is possible or whether every
> > device needs to have an application specifically tailored to that
> > particular device.
> >
> > If we say that it is feasible to plug a device into FF layer then we
> > must not expose hardware implementation details. That means that
> > device-sepcific translation between 3d vector of forces into motor
> > torques must be done by the driver itself.
>
> Hmm, it's 3d at minimum (the glove has 14 torque points, phantom up to
> 6),

The vector of forces is always 3d in our world.

> I think we won't be able to make the transition in independent way
> due to unspecified meaning of the torques.
>

With phantom it still seems doable - if I understand correctly ther is
one point of containct and one resulting vector of forces applied to
user's hand. With the glove there are multiple points of contact and
multiple feedback effects applied to different part of hand
simultaneously and that is for sure requires special application.

-- 
Dmitry
