Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbXEVIWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbXEVIWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXEVIWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:22:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXEVIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bi/J3+U+M9wukXcXALK3WyiHt9jhuBN4tEKD8VXikqh+4QTjWsvsLwyqnVHZ6GMd4FBkKPYPCpZ7Yb7E161GQcUQsDyTw8wwM9OD10LtGgfMfsFpMEJ3JgWB4G4GwPqC2KwWQHSALXPo9smwpsMGSDg+OzI01gKue4RZAWQ3bD8=
Message-ID: <21d7e9970705220121v78fe4f1by6539136f6823977a@mail.gmail.com>
Date: Tue, 22 May 2007 18:21:57 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705211756g3b72795ucc4a8883ff587861@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <4652295E.7060305@garzik.org>
	 <20070522013545.5c269641@the-village.bc.nu>
	 <9e4733910705211745q40de7683xb6ede752b53538ed@mail.gmail.com>
	 <9e4733910705211756g3b72795ucc4a8883ff587861@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What I don't want is a permanent root priv process hanging around in
> the system. It simply isn't needed and I have prototyped a system that
> runs without root so I know it can be done. With minor mods DRI can
> run without the need for root, with more major mods the X server can
> run without the need for root. Most of the mods to the X server are to
> remove things like PCI bus probing, mode setting and VBIOS support.
>

But you always lacked a transition plan and never showed a decent API if memory
serves, your methods disregarded back compat usually.
also there is no need to port all drivers there never has been we need
to just add config options and work with distros to upgrade to the
newer bits..

As Jesse  said this is an RFC we are not merging it in the morning
however all your comments are hand waving so far we need technical
problems with this API.

Dave.
