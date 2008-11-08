Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYKHKW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYKHKW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKHKWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:22:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:64291 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYKHKWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QK+axPdc/VSoId1iVavbMftv4eJShGQpTBdiOxoXS+6EsavlFtaDgpZLIWdGU7oQnW
         5NscmAFiLtz8VcB4cIT8m/X66ZtxSz8uw3o6zJmsx08VdQwZXwfLI5iCRtq2Vr+OXgBL
         lK8d3gmKGB26B61zEnFGwAPr5+jiNcDUtYxf0=
Message-ID: <d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
Date: Sat, 8 Nov 2008 11:22:16 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Andre Kelmanson" <akelmanson@gmail.com>,
       "Hans Verkuil" <hverkuil@xs4all.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       greg@kroah.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081108081508.496f6582@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <200811011459.17706.hverkuil@xs4all.nl>
	 <20081102022728.68e5e564@pedra.chehab.org>
	 <a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
	 <20081108081508.496f6582@pedra.chehab.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2008 at 11:15 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Sat, 8 Nov 2008 03:50:20 -0200
> "Andre Kelmanson" <akelmanson@gmail.com> wrote:
>
>> Dears,
>>
>> I'm using this version of em28xx for a long time and it's working fine. It
>> has three very important features for me. The first one is Kaiomy device,
>> the second one is the new em28xx-audoep module and the third one is PAL-M
>> support. Kaiomy and PAL-M support were developed based on my support on the
>> em28xx mailinglist.
>>
>> Now I can use my device (Kaiomy) outside Windows with sound (em28xx-audioep)
>> and colors (PAL-M)! I'm using this version everyday with no problems.
>>
>> Because of this, it will be nice if this work could be included in the
>> kernel code. What do you (other users) think about having that driver in
>> kernel?
>
> André,
>
> First of all, the big issue why we aren't merging em28xx improvements from
> Markus is that he is not following the rules.
>
> For example, you said that you've contributed with Markus tree.
>
> However, on Markus pull request, I see no patch from you on his series of patches.
>
> The correct procedure would be just to forward your patch as-is, adding with his SOB bellow yours.
>
> Not doing this, he would be considered as the author of your patch. IANAL, but
> this doesn't seem to be right, from GPL's perspective. Probably, there are
> other patches there not authored by Markus that are just merged inside his big patch.
>
> About PAL-M, this always worked at the upstream driver. I have myself lots of
> em28xx devices, all working in colors with PAL-M, and with audio. I live in
> Brazil, so I always check if PAL-M is ok ;)
>
> If you want to have your device supported, just send us a patch against the
> upstream driver.
>

As written earlier already I don't think that I didn't follow any
rules here since I provided single
patches at the very first beginning

http://mcentral.de/v4l-dvb/
(this is all kernel code and only kernel code).

That work didn't get attention and due a different decision of
framework changes (which that codebase relied
on) it all had to be rebased, I doubt that anyone
would have reworked all that patch for patch. Instead it went into one
repository and finally got modified to work again
with the available framework rather than relying onto any such modifications.

The modification which I received from André suggested to use the NTSC
VBI offset lines for PAL-M, and the
rest for audio comes from my side.

Markus
