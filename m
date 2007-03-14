Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbXCNTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbXCNTNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbXCNTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:13:34 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:20946 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbXCNTNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oqS/1mksuQK3lWcSmZtaORZXGiT10tNPcNRxnRUp+eE2t669lhMIrekkGjWb5RWiLe2stgdPzljGPsCXtHaeejABOODgHaRPKXIrrMRaorUOZAF/xU8thTEfp/Y2cShuhDP0rH/j69agF6vycrdkLFSmi/MTEGtEpnZkg6814B4=
Message-ID: <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
Date: Wed, 14 Mar 2007 15:13:31 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "johann deneux" <johann.deneux@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <45EEEAA3.50009@gmail.com>
	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>
	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, STenyaK (Bruno González) <stenyak@gmail.com> wrote:
>
>
> On 3/14/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
> > >> Do we have any idea if there any users of FF out there?
> > >
> > > At least me :). I'm using it for wheel and joystick in modules for
> locally
> > > developped multiplatform virtual reality system.
> >
> > Wine and BZflag come to mind, though I think the support is quite
> > limited in both.
> >
>
> There's also vDrift (racing sim), they added support very recently.
> I plan to add it in my car sim too, but there's still nothing coded.
>
> I have a question: if the force is to be 3D, why only 3 possible values?
> What would they be, 3 torques or 3 forces? In the case of car sims (ff
> steering wheels), only one axis of torque is usually used (except for 6 dof
> platforms, as mentioned).
>

I wonder if we could somehow extend or augment FF envelope se we could
specify a plane for the effect.. Then a vector could be represented by
a sum 3 constant effects in 3 separate planes and we could also use
spring and other effects as well.

> By the way, is this the correct list for asking trivial questions (such as
> questions about how the ff api works), or is it only for development of
> kernel?

Since it is kernel-provided API linux-input list should be fine and I
think linux-kernel as well.

-- 
Dmitry
