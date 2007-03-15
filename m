Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbXCOUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbXCOUvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXCOUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:51:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:60423 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbXCOUvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uJ1O3UHdcf5osRMFg3CjsX8wE01dSZPx/KOu7XauGJRpKC7o5XwnuyN8GYGq2c1yy4J+daI0yc1PMsAJW2I8g6BOP2XCCSlCq9AESIxmN8l02M/ZuYA7vRe1HK7b1Q7DjaOcmxsCVhk17WJ7M057feG+OKRwad6YCmjgRvxe1dU=
Message-ID: <38b3b7c0703151351i23d42d67n1d7469fd14e433e2@mail.gmail.com>
Date: Thu, 15 Mar 2007 21:51:07 +0100
From: "johann deneux" <johann.deneux@gmail.com>
To: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
	 <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, STenyaK (Bruno González) <stenyak@gmail.com> wrote:
> On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > I have a question: if the force is to be 3D, why only 3 possible values?
> > > What would they be, 3 torques or 3 forces? In the case of car sims (ff
> > > steering wheels), only one axis of torque is usually used (except for 6 dof
> > > platforms, as mentioned).
> > >
> >
> > I wonder if we could somehow extend or augment FF envelope se we could
> > specify a plane for the effect.. Then a vector could be represented by
> > a sum 3 constant effects in 3 separate planes and we could also use
> > spring and other effects as well.
>

I would think one plane and one axis is all that's needed for a 3d vector, or?
Do we understand eachother?

> Ideally, afaik we should use:
> -3 values for translation force (linear force): x,y,z components of
> the force vector.
> -4 values for rotation force (torque): x,y,z,w components of the
> quaternion. You can also use euler angles (and i think there are
> another one or two notations), which is just 3 values, but i'm not
> sure it will be a correct decision (due to the gimbal lock problem,
> which may or may not be present in ff devices, dunno).

Same remark here. A torque is a 3-dimensional thing, just like a
force. What for do you need 4 components?

-- 
Johann
