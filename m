Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYASWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYASWSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYASWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:18:44 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:44796 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYASWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YmPWS1WC9BThzMZF4LBzvm++VIK5Ujr2rKGFYT2623+5PbEVauZZI3GhGCqewbyOCLnelirhUjb8+3tRZr/PTwUYmjaQNKHAqwHPHIcbq3vy7AeGy7kIr4RIJuUhAIuaI/xmkYpN/XAS+z6CS3nv8RbBgGP8aIl09jZsu21uI1E=
Message-ID: <bc64b4640801191418m6b8197c8l498e181d267bb200@mail.gmail.com>
Date: Sun, 20 Jan 2008 01:18:40 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       liam.girdwood@wolfsonmicro.com
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
In-Reply-To: <20080119215506.GA7400@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080118162627.GA28974@rakim.wolfsonmicro.main>
	 <1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20080118120148.ZZRA012@mailhub.coreip.homeip.net>
	 <fmqq50$te0$1@ger.gmane.org> <20080119170030.GA469@sirena.org.uk>
	 <bc64b4640801191148m39ae5cd6ra190ac8e9c40fba7@mail.gmail.com>
	 <20080119215506.GA7400@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/1/20, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sat, Jan 19, 2008 at 10:48:32PM +0300, Dmitry wrote:
>
> > Well... It's a common suggestion not to duplicate code. The wm97xx bus
> > looks mostly like platform. The only difference is the name. To help
> > visualisation, devices can have parents. Just set (in pseudocode)
> > wm97xx-touchscreen->parent to wm97xx, do the same for wm97xx-battery
> > and so on. Thus all devices would be on the platform device but with
> > proper parent <-> child notation.
>
> That's exactly what I had understood you to mean.  I guess it's just
> that using the platform bus for this purpose feels like an abstraction
> violation to me due to having platform devices parented off a device on
> another bus.  Obviously it's just my model of a platform device that's
> wrong here.  I will change the driver to use the platform bus for my
> next submission.

Hmm. I forgot about rooting this onto ac97 bus. But I would still suggest
using platform bus just for the sake of code clarity and simplicity.

>
> > git://git.mnementh.co.uk/linux-2.6-im.git#tmio_dev_try3. Look for
>
> Thanks, I'll take a look.
>
> > 2008/1/19, Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
> > > current patch series these chips all also provide an audio codec which
> > > requires a reasonably substantial driver for full support.
>
> > This would only touch child devices organisation.
>
> Indeed - I mention it mostly for additional motivation.
>


-- 
With best wishes
Dmitry
