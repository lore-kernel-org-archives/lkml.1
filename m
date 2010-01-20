Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866Ab0ATXBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0ATXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645Ab0ATXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:01:39 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60516 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0ATXBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=RikAkgpvgssg7rn4F0WsL7BH+NmV0SE/2TRe0fKOpzX8GkB8jpjuQ0wxHsvrnErY2G
         2zLaH25lTsstduML0wMujasUpdrE78WYDEx2USKpXPZUhihNKsLzndzSVQClgdRR/U/u
         iDVEG1tww3c1lAwjv0lEAvyS1WWLgMcrwtqok=
MIME-Version: 1.0
In-Reply-To: <1264027973.5591.241.camel@localhost.localdomain>
References: <1264017679-19324-1-git-send-email-lrodriguez@atheros.com> 
	<1264019268.5591.223.camel@localhost.localdomain> <20100120210813.GF10113@tux> 
	<1264027973.5591.241.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 20 Jan 2010 15:01:17 -0800
X-Google-Sender-Auth: 9a70c3db960ed627
Message-ID: <43e72e891001201501n2088a40fn7d6ca2bef50c7c10@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Add DFU driver for Atheros Bluetooth chipset 
	AR3011
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
       SongXing Xu <SongXing.Xu@atheros.com>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 2:52 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> As I said, if Dave is willing to take it, then I cherry-pick it for you
> and include it with my next round of fixes.

Well it enables hardware, so yes, I think it'd be good to add to
2.6.33-rc5, despite its historical issues on route upstream. Otherwise
I have to poke distributions to carry the driver externally anyway,
and I don't see the point in that if we still have a few RC cycles
left and this driver is really small.

Dave, please let me know if including this driver is unacceptable. I
honestly fail to understand the reasons for it to not go into
2.6.33-rcX.

  Luis
