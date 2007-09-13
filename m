Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXIMNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXIMNRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXIMNRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:17:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:56873 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXIMNRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eN0vm6/cFt0G3VW7z1/NruEhuF7zn0zegzB/wIWlwsgdNxE5PJNlP30Kas9NUTN3Ys9bAtGxN3li6Ji2UVTkdWXMs5raayMSlR613F1iraZV9BHyOJ+kImv5vyOtCvdhmBFqjTjm/rr5SBzxwRup/x76miG+w2BIGm0IXc7ar0k=
Message-ID: <d9def9db0709130617o3d4d555du59f9e422f062ae29@mail.gmail.com>
Date: Thu, 13 Sep 2007 15:17:12 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "=?ISO-8859-1?Q?D=E2niel_Fraga?=" <fragabr@gmail.com>,
       video4linux-list@redhat.com, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070913124034.GA26972@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <rjsmr4-rc8.ln1@tux.abusar.org>
	 <d9def9db0709122258l4b05546dq2e370e67a2a1404@mail.gmail.com>
	 <20070913124034.GA26972@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/13/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Thu, Sep 13, 2007, Markus Rechberger wrote:
> >
> > We currently have an implementation that works, although
> > it works by downloading several firmwares for several devices
> > or even several countries. This is not what I want to have in
> > future since it's not needed and it's also hard to manage for
> > distributors. All those differences could be adjusted by
> > software even without module parameter hacks.
>
> This argument doesn't hold water. The unpleasant point
> for users and distributors isn't the "binary-only"
> thing, it's the "no right to distribute" problem.
> And that's the same for firmware blobs or binary-only
> userspace blobs.
>
> IOW, if you can get the right to redistribute a binary-only
> userspace blob which incudes the firmware inside, why
> shouldn't you be able to get the right to redistribute
> just the firmware?
>

In particular xceive based drivers provide a numerous set
of features which cannot be implemented into the kernel
because the API (both V4L and DVB) are limited.
Since to me it seriously has the impression that the project
especially the core of the project is closed to the outside
world (just how someone stated it out recently
"he licked the butts of others" to get his stuff accepted)

> Or the other way round: Do you think your binary-only software
> will be important enough so distributors will go through
> all the trouble of trying to get a license to include it in
> their distribution? If so, why wouldn't they do the same
> for the plain firmware blobs for in-kernel drivers?

I don't have any binary only software just as all the time before.
I am also allowed to publish firmware for several drivers
(not only the em28xx driver). Although as mentioned earlier
already the current existing driver is not really manageable
due the firmware mess and that driver will change completly
and include templates for several other bridge drivers.

Markus
