Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbYD1I3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbYD1I3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765863AbYD1I3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:29:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:65434 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765407AbYD1I3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TYW/SlCaeeJ7skbP4EaXXcQr32U7l3SP3CSaJ30VFy8iU7jUuEZfD6oDiz2wEEbkmeDDtGuelpHMFiJjULwkoFHhqcoEXAodOF82ggtNqMNLeeD0VHUELz8M8JGlVgd3JsELoP2szMvd9+L0iiFRpPo+0B8hX1gDSjAe+cb0HVI=
Message-ID: <1ba2fa240804280129r48762639jac501a3010e132a6@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:29:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Cc: "Luca Tettamanti" <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "Priit Laes" <plaes@plaes.org>
In-Reply-To: <20080428082030.GD16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426203408.GA12074@dreamland.darkstar.lan>
	 <20080428074531.GA16379@cs181133002.pp.htv.fi>
	 <20080428075452.GB16379@cs181133002.pp.htv.fi>
	 <1ba2fa240804280118l5f813b38n8291789342b1d802@mail.gmail.com>
	 <20080428082030.GD16379@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:20 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Apr 28, 2008 at 11:18:08AM +0300, Tomas Winkler wrote:
>  > On Mon, Apr 28, 2008 at 10:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
>  > > On Mon, Apr 28, 2008 at 10:45:31AM +0300, Adrian Bunk wrote:
>  > >  > Can you send the .config that gives this problem?
>  > >
>  > >  Scrap that, I already got the problem (and your patch looks right).
>  > >
>  > >
>  >
>  > I think it's time to be applied so we won't get another 5 of them.
>  > Please add also  Priit Laes <plaes@plaes.org>  as he was first to
>  > provide a patch
>
>  David already sent a pull request that includes Luca's patch to Linus.
>
>  My question was due to me first misunderstanding what's happening here.
>
I see... I wasn't subscribed so I missed that.
Anyhow what is happening is that I've assumed that 'select' is
transitive and selecting MAC80211_LEDs is enough.

Tomas
