Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYBQARn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYBQARn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYBQARe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:17:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:55503 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYBQARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BAjmX/kha9ISAphgYcESSCZ2+ZH1D61F7PZU04dVkKQ4i4q7AE2tmya2jjBrW6wT9B8Uk7L8qBb+zaAJtzADDdg2zoZdiJZe/W04rdJv4M6qW0Qx8gDUN1Oagv7fUMXnBdcr40M8SFV6zlEdpTJADv4wt1nIJM5Jx9B+k9Mxw6k=
Message-ID: <5a4c581d0802161617h284574aar7d4d72e87ecbba49@mail.gmail.com>
Date: Sun, 17 Feb 2008 01:17:31 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: 2.6.25-rc2: wpa_supplicant BUGs kernel in rwlock recursion
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Laszlo Attila Toth" <panther@balabit.hu>,
       "David Miller" <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <3d8471ca0802161518h3fe87f5encc83e7cc976ccef9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
	 <3d8471ca0802161518h3fe87f5encc83e7cc976ccef9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 12:18 AM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> On Feb 16, 2008 6:14 PM, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> > Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,
>
> Same thing here, bisected it to:
>
> commit 45b503548210fe6f23e92b856421c2a3f05fd034
> Author: Laszlo Attila Toth <panther <at> balabit.hu>
> Date:   Tue Feb 12 22:42:09 2008 -0800
>
>     [RTNETLINK]: Send a single notification on device state changes.
>
> The revert applies cleanly and fixes the problem.
> Rafael has more details in http://lkml.org/lkml/2008/2/15/542.

Thanks Guillaume,

  I can confirm that the revert of the rtnetlink.c changes does
  indeed fix the problem for me.

Second time in a couple of week I hit the same bugs as Rafael,
 will keep an eye on his new findings ;)

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
