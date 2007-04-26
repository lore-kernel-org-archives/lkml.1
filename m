Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbXDZDe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbXDZDe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXDZDe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:34:28 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:13451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbXDZDe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FRIq3Ih9gByeSlRTI4dmnlbAyHyufBN7XssFuJ2ZENDduL9WMo0NQK5KJA+NC1f2uic2M4ddmx61dc/hhYUTTg4p/gFnaILEIVTg3z+vfb+NrsoeD2S3wajqGkiPiVFct2+0ekJ5jtesYUMhY/VfkzajtJ5Z48xjFObdS6HZ6kg=
Message-ID: <ff1613620704252034j2474f3f8j73eaa66f4499d258@mail.gmail.com>
Date: Thu, 26 Apr 2007 09:04:26 +0530
From: "Madhusudhan c" <cr.madhusudhan@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: MMCv4 support (8-bit support missing)
Cc: linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <462D8FA2.5010609@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
	 <4625DAFC.4000208@drzeus.cx>
	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
	 <46262953.3040801@drzeus.cx>
	 <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>
	 <462797EE.2050808@drzeus.cx>
	 <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
	 <462D8FA2.5010609@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre/Philip,

> I've looked through the MMC 4.2 spec and I see nothing in it that even hints
> that 8-bit support might be optional. So as it stands, the bus testing is still out.
Okay. Its possible that my understanding was wrong in the sense that I
thought bus testing procedure is mandatory to support 8-bit cards. If
8-bit is mandatory for MMC4 cards, then the changes required in the
MMC core to support 8-bit might be  simple. Based on host controller
cap this can be handled.

Philip asked me about the access to the 8-bit controller. We might not
be able to provide you direct access to the hardware platform as it
requires involvement of business managers and so on. But can I be of
help by testing your code on our platform and leting you know the
results?

Regards,
Madhu



On 4/24/07, Pierre Ossman <drzeus@drzeus.cx> wrote:
> Madhusudhan c wrote:
> >
> > Suppose a host controller is capable of suporting 8-bit and it tells
> > the core that it can support 8-bit. Now the card that is plugged in
> > might or might not support 8-bit based on the type of the card. There
> > is no field in the ext_csd which will tell you what bus width the card
> > can support.
> >
>
> I've looked through the MMC 4.2 spec and I see nothing in it that even hints
> that 8-bit support might be optional. So as it stands, the bus testing is still out.
>
> Rgds
> Pierre
>
>
>
>
