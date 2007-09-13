Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXIMQJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXIMQJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXIMQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:08:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:15451 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbXIMQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DT5KTZpXt2ISxj7wdmoG3Td9nW/ktlxpMkzHHGq/fRaTLNhJKrW6pvq7LqPVOwRlDZm/rJaRTs0YBrI+zLMbx6DRmS7/cE0EWKN6IHRN/OcQg9ugoW1OhGxBdywgB2TW8N2pWh2zFdGWHZROb0wuCHS2hPLQu3eVv7CiidFxEXg=
Message-ID: <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
Date: Thu, 13 Sep 2007 18:08:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Johannes Stezenbach" <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       akpm@linux-foundation.org
In-Reply-To: <46E95C54.4060502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Manu Abraham <abraham.manu@gmail.com> wrote:
>
> > It's only a step in development, I do not intend to keep the kernel
> > stub in the end, but I do intend to keep and use the userspace drivers
> > with i2c-dev in the long run, this requires a v4l/dvb library at the front
> > of everything.
>
> Well, this was what adq and myself did with libdvbapi and mti, (much
> before UIO was announced at LK.) It is not tied to I2C either.
>

I2C is the main communication path for it, although there are callback
mechanisms available which add the possibility for different configuration
paths.

> But, according to your statements (with regards to i2c-dev) you can
> handle only some I2C based devices, which is in fact a subset of a
> subset. Also not to forget that hardly a few I2C devices are in fact
> "truly" I2C compatible. In fact many variables to be considered.
>

The analogue tuner core is also only for i2c only devices which most
devices rely on.

> Also there is to consider a non technical aspect, whether vendors will
> misuse this interface for binary only, undermining the efforts put in
> for OSS drivers.
>

What holds companies for using the current available code putting it
into an rpm or deb package and releasing such code now?

The Avermedia example I pointed out to is a good example already.
As from my side I won't release binary drivers.
Although on the other side:
* are drivers from vendors which work through several kernel versions
that bad?
* Why did someone duallicense videodev2 with BSD/GPL?

I would appreciate if someone else on the list could also comment
the reason that drivers should all be included in the linuxkernel just
because forcing the companies to release binary drivers because
of that. My opinion about that is if a company wants to go opensource
they will do so, if not they will either not release a driver or release
nothing.

Markus
