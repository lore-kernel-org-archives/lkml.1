Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbZLOU2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbZLOU2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbZLOU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:28:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11509 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbZLOU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:28:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5833"; a="30012036"
Subject: Re: GPIO support for HTC Dream
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20091215191229.GC26422@elf.ucw.cz>
References: <4B203575.6050407@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
	 <20091214064545.GK5114@elf.ucw.cz>
	 <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
	 <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
	 <d6200be20912142240q5e7785e6h57fae538a5f4ea4e@mail.gmail.com>
	 <20091215191229.GC26422@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 12:07:06 -0800
Message-ID: <1260907626.32296.16.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 20:12 +0100, Pavel Machek wrote:
> > > One other thing.  Are the gpio's handled by Pavel's driver actually from the
> > > MSM chip or from an external CPLD?  The registers are all defined as:
> > >
> > > +               .reg = reg_num + DREAM_CPLD_BASE,
> > >
> > > If they are external from the MSM chip this driver should probably be renamed
> > > to something more appropriate since it is probably dream specific and not
> > > generic to the msm architecture.
> > 
> > These are board specific gpios. I think it would be less confusing if
> > the msm gpio support was added first.
> 
> I did not see msm-generic gpios in the trees, where are they? What is
> connected over them?

Did you look at arch/arm/mach-msm/gpio.[ch] ? It looks like there some
idle related code in there, and "SMEM" is connected through that code.
(unless I'm looking at an older tree.)

Daniel

