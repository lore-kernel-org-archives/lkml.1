Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423Ab0AaVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0AaVDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129Ab0AaVD3
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:03:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45400 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0AaVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qn8Z7AXRwwT5CxTvFxJ02xVwO0ngKTyP42DmIUl4bJPaWLIhrwnGlcMjsxW/MkLo18
         dW9BIquvGyRQe+Dy3krHbsTaAHfkjHdxZL0G/Ijes8riNp9Uy7Uh+KMpgIdVWx3jA7a+
         BUYlClK1yhVaVAyfa4wG9zgH9mYtUpQoIFaVA=
Message-ID: <4B65F024.3080505@gmail.com>
Date: Sun, 31 Jan 2010 22:03:32 +0100
From: Witold Sowa <witold.sowa@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
       Till Kamppeter <till.kamppeter@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, lsb-discuss@lists.linux-foundation.org
Subject: Re: Linux wireless GSoC 2010 project ideas
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
In-Reply-To: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez pisze:
> Google has confirmed it will have a Google Summer of Code for 2010
> [1]. Last year we had a few projects suggested (4) and accepted (3)
> under the Linux Foundation sponsoring organization umbrella [2].
> Unfortunately out of the three projects that were approved only one
> completed successfully, that of the adding AP support to Network
> Manger. I haven't seen specific updates to the progress of that but I
> do know some patches were indeed submitted to help with this effort.
> Perhaps the student can elaborate more.
> 
Hi Luis,

I didn't know that I was _the_only_one_ student who completed his
project. My project goal was to add support for AP mode to
NetworkManages with use of wpa_supplicant's newly developed AP mode.
When the GSoC started, it turned out that adding AP mode to NM doesn't
need too much effort or at least a lot less that I could put during
three months of work. As the result, I focused on development of new
DBus API for wpa_supplicant. We have designed it together with Dan
Williams (he designed it with my little help, actually) and I
implemented it. The new API is present in wpa_supplicant since 0.7.0
development version and we are still working on it.
I've implemented the new API support for NetworkManager, but Dan didn't
apply it (yet). Since the API has changed lately, we will need alter
NetworkManager too. I'm going to do this when the API will reach more or
less stable state. AP mode for NetworkManager is dependent on new
wpa_supplicnt DBus API, so the NM AP mode patches won't be applied
before the new API support implementation patches. The NM changes won't
land earlier then in 0.8.1 version for sure.

Some time ago johill asked me if I would be interested in hacking on
adding WPS support to NetworkManager. Well, I would but I don't know
when I'll find some time for that. I don't know how much of work would
it require, but it possibly could be a topic of one of GSoC 2010
projects. I have no idea know if anybody would be willing to be a mentor
for such a project.

Regards,
Witek.
