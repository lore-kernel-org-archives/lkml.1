Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbXCNTS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbXCNTS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXCNTS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:18:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:31440 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbXCNTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J6qGEbrQLNYcwf681gqS670eqPPUgZRuo4bBu/K4+FHmCWsEUofO0RjOiK/KpcIqnVijDmOKjIcQlQfBDlJ4hv51l0gbTdJ0GNzKWYRRbdcLogWn7qCal1OtYI2EcEku9d1WffT8TCaXz405SwKs9JSatJTZiBxxCjjKRqL2lXo=
Message-ID: <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
Date: Wed, 14 Mar 2007 20:18:54 +0100
From: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "johann deneux" <johann.deneux@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>
	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > I have a question: if the force is to be 3D, why only 3 possible values?
> > What would they be, 3 torques or 3 forces? In the case of car sims (ff
> > steering wheels), only one axis of torque is usually used (except for 6 dof
> > platforms, as mentioned).
> >
>
> I wonder if we could somehow extend or augment FF envelope se we could
> specify a plane for the effect.. Then a vector could be represented by
> a sum 3 constant effects in 3 separate planes and we could also use
> spring and other effects as well.

Ideally, afaik we should use:
-3 values for translation force (linear force): x,y,z components of
the force vector.
-4 values for rotation force (torque): x,y,z,w components of the
quaternion. You can also use euler angles (and i think there are
another one or two notations), which is just 3 values, but i'm not
sure it will be a correct decision (due to the gimbal lock problem,
which may or may not be present in ff devices, dunno).

-- 
Saludos,
     STenyaK

_______________________________________________
Site:   http://1ksurvivor.homeip.net  <1kSurvivor>
         http://motorsport-sim.org     <Motorsport>
         http://kwh.iespana.es         <KuantikalWareHouse>
         http://emuletutorial.info     <EmuleTutorial>
ICQ:    153709484
Mail:   stenyak AT gmail DOT com
