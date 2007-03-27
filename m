Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXC0Unt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXC0Unt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXC0Uns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:43:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:30475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbXC0Unr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pOQ4EujLvGLNwUb8I2t8YOTveqLEQzR6aIaUpiqPhCVkhSyVxm3sXi/QRYKamEVEEwbjYVF+K9x5iSSIm2+aMXT9mTV4knwi+z2hpH/rpaJhk33qCVWb985mNwYEJiJm3EPcqSC3PnHPUhwdWBGQXoLS4INaGczRmWlTlB5dkLE=
Message-ID: <38b3b7c0703271343p6a56fed8i950941e8cef196d8@mail.gmail.com>
Date: Tue, 27 Mar 2007 22:43:45 +0200
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "=?ISO-8859-1?Q?\"STenyaK_(Bruno_Gonz=E1lez)\"?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <46097A68.6080802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com>
	 <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>
	 <200703221150.12403.dtor@insightbb.com> <46090BF2.2000105@gmail.com>
	 <38b3b7c0703271136s799114fcndfaa6de8db52fc70@mail.gmail.com>
	 <46097A68.6080802@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> johann deneux napsal(a):
> > On 3/27/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> Dmitry Torokhov napsal(a):
> >> > On Wednesday 21 March 2007 18:03, johann deneux wrote:
> >> >> I have forgotten the details of ioctl: Wouldn't the
> >> >> following work?
> >>
> >> No, at least, as far as I understand this. I have computed _torques_, not
> >> forces vector (this was misleading info in my first post), the
> >> question is
> >> "how can I pass torques through plane and direction entries into KS?".
> >
> > Torques and forces are both represented as 3d vectors.
>
> Yes, may be.
>
> > Are we
> > misunderstanding eachother maybe? By "vector" I mean a triplet of
> > numbers, when you say "torques" and "forces vector", do you mean that
> > each effect is composed of a bunch of torques?
>
> Ok, let's make things a little bit clear. I need to put somehow 3 short
> values (torques -- to tell 3 motors how much to spin around) into the kernel
> space via ff layer. I computed them using FP in US from forces (3d vector)
> and the problem is, that I don't know how to transform torques to plane(s)
> and dir and then back to torques -- this is what I can't figure out, since I
> have no longer vector -- 3 values for each axis, which says how big is the
> force in each axis -- but I have values (no axis) specific to each motor.

I think I'm starting to understand. Looking back at the url you gave,
it appears your device is some kind of articulated arm, possibly with
one or more motor(s) at each joint. You are not really dealing with a
single torque applied at one point in space, but several torques
applied at several points in space.
For this particular device you have three values, but for other
devices it could just as well be any other number, right?
A realistic example would be a robot arm with claws, there would be a
torque for each joint, and some more for the claws.

-- 
Johann
