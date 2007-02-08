Return-Path: <linux-kernel-owner+w=401wt.eu-S1422824AbXBHATK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbXBHATK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXBHATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:19:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:20399 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422824AbXBHATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CamFFiRnCk52kaUY1ggaZTiMpyvnT33aJXqbR2TYIWgYJJhkf65WaB6IhWHrN5RTx7Yo6KD9TMGpjMlhD6foG1xA1A+qc+k7TqqLarx4lK27CcRJ5eDLajszefk7S/lsulW1SD3izH+jhfKe+dhMi31izrxCEgk/P3MGqiQ9DoE=
Message-ID: <cb7bb73a0702071619p5984c39fs16e3d05c11d45585@mail.gmail.com>
Date: Thu, 8 Feb 2007 01:19:08 +0100
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Luca Tettamanti" <kronos@people.it>
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Cc: "James Simmons" <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@osdl.org>, "Dave Airlie" <airlied@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070207234837.GA27822@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <cb7bb73a0702041317u4ca2fbabp45cf56526e57c982@mail.gmail.com>
	 <20070205201824.GA13431@dreamland.darkstar.lan>
	 <cb7bb73a0702051328n50c889d9o461ac2bb9f9ea75e@mail.gmail.com>
	 <Pine.LNX.4.64.0702062118450.9224@pentafluge.infradead.org>
	 <20070207234837.GA27822@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Luca Tettamanti <kronos@people.it> wrote:
> Il Tue, Feb 06, 2007 at 09:22:00PM +0000, James Simmons ha scritto:
> > There is no stand alone nvidia card i2c driver. Its the issue of sharing
> > device interfaces with the same hardware problem again!!!
>
> Nah, nvidiafb registers the I2C busses, you can drive them with whatever
> you want through the devices exported by I2C core.
> The fact the none of them work makes me think that the EDID is coming
> from the BIOS, we do VBE calls in real mode during early kernel setup.

So what am I supposed to do to dump it, since neither i2cdump neither
get-edid seem to work?

-- 
Giuseppe "Oblomov" Bilotta
