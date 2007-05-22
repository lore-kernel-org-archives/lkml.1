Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXEVA4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXEVA4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXEVA41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:56:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:27410 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbXEVA40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BzcwsT0+frv6pvz6MiY1MfcYxEALPC5dA5ar70vrmlsrhUGvQ6O+c9+CSNqmh/EzbzSce5n/hAHvYeS58nQQaL6/qwia28kOsIUljVCzsVmQ8WZnDqUj8xdGXmFum/gigvbdLbqmM/yivZ3B8W6raqpILXl21NhyyAJzCe58wRM=
Message-ID: <9e4733910705211756g3b72795ucc4a8883ff587861@mail.gmail.com>
Date: Mon, 21 May 2007 20:56:25 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jeff Garzik" <jeff@garzik.org>, "Dave Airlie" <airlied@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705211745q40de7683xb6ede752b53538ed@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So why do you want it in kernel.... security is not the sensible answer
> > here.

I'm not proposing the KGI solution where every device driver presents
the same API. That model does require a lot of code in the kernel.

The existing DRM model where each driver provides it's own API is a
good one. The user space DRI driver then takes this API and turns it
into a standard one. Applying the DRM style model to fbdev may allow
parts of fbdev to be moved out to user space.

What I don't want is a permanent root priv process hanging around in
the system. It simply isn't needed and I have prototyped a system that
runs without root so I know it can be done. With minor mods DRI can
run without the need for root, with more major mods the X server can
run without the need for root. Most of the mods to the X server are to
remove things like PCI bus probing, mode setting and VBIOS support.

-- 
Jon Smirl
jonsmirl@gmail.com
