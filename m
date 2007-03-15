Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXCOVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXCOVG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXCOVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:06:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:3529 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXCOVG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nnPgQDF03+ddS8KT1wy0M3ztRhuA8CDso89KCkrq79sQenm3NFodeet3Iysc4LZkpHqiI37wBW+oWLA4rboOt5nJ26cJi2NGcH5OO2YfsCO2vQTzw2KzPk3Gk5qgdPdpdy/b2r/BKvvzu2Gkdzd4HhD+BrhTvm0m9NwdHFBLMpk=
Message-ID: <8e4ff20a0703151406v77dbf67fh2071f349065d40d4@mail.gmail.com>
Date: Thu, 15 Mar 2007 22:06:54 +0100
From: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>
To: "johann deneux" <johann.deneux@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <38b3b7c0703151351i23d42d67n1d7469fd14e433e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
	 <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
	 <38b3b7c0703151351i23d42d67n1d7469fd14e433e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, johann deneux <johann.deneux@gmail.com> wrote:
> On 3/14/07, STenyaK (Bruno González) <stenyak@gmail.com> wrote:
> > Ideally, afaik we should use:
> > -3 values for translation force (linear force): x,y,z components of
> > the force vector.
> > -4 values for rotation force (torque): x,y,z,w components of the
> > quaternion. You can also use euler angles (and i think there are
> > another one or two notations), which is just 3 values, but i'm not
> > sure it will be a correct decision (due to the gimbal lock problem,
> > which may or may not be present in ff devices, dunno).
>
> Same remark here. A torque is a 3-dimensional thing, just like a
> force. What for do you need 4 components?

Simplifying, 3 values defining axis of rotation, 1 defining module of
torque.. As i said, i'm not really sure we really need the 4; you most
probably are right.

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
