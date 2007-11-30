Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXK3Igr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXK3Igr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbXK3Igd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:36:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:13327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbXK3Igc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a1FoYSFDQs1ZoQwxyBQKClb/csoWmcwATnnb4BRdMQ0vo9j6P8gNw9aBqU4WoarYPuXN8pb+kfsaOUSm/w5KXicpK9o5tQLnkFkKUlv87/zu0RKiXiAYVIpxHE9fKtgNLUUZGNGqIwvWRcuuL+VgIj9FxbY1Spr0YuS6N4RBB6Y=
Message-ID: <3ae72650711300036o92832e3ofa7ea02f7ed83222@mail.gmail.com>
Date: Fri, 30 Nov 2007 09:36:31 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 1/3] bdi patches
Cc: neilb@suse.de, a.p.zijlstra@chello.nl, fengguang.wu@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Iy0tl-0003qA-2U@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
	 <18255.24276.519113.975347@notabene.brown>
	 <E1Iy0tl-0003qA-2U@dorka.pomaz.szeredi.hu>
X-Google-Sender-Auth: 9412d1d7052a341d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007 9:06 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > Provide a place in sysfs for the backing_dev_info object.
> > > This allows us to see and set the various BDI specific variables.
> >
> > You don't say what the place is, and I'm not quite familiar enough
> > with sysfs internals to figure it out my self.  Help?
>
> /sys/class/bdi  (which sometimes links into /sys/devices/virtual/bdi)
>
> > And while I was looking I noticed that bdi_register (and bdi_init_fmt)
> > takes a second argument 'parent', which is always NULL, and which is
> > undocumented as to purpose.
> > If no-one would ever add another call to bdi_register, why have the
> > second arg, and if they might, how would they know what to put there?

It will get the parent after the block devices are converted from raw
kobjects to core devices. The patch is in Greg's tree.

Kay
