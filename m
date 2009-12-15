Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbZLOTMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbZLOTMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933378AbZLOTMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:12:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42605 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbZLOTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:12:37 -0500
Date: Tue, 15 Dec 2009 20:12:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215191229.GC26422@elf.ucw.cz>
References: <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
 <20091214064545.GK5114@elf.ucw.cz>
 <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
 <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
 <d6200be20912142240q5e7785e6h57fae538a5f4ea4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20912142240q5e7785e6h57fae538a5f4ea4e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One other thing.  Are the gpio's handled by Pavel's driver actually from the
> > MSM chip or from an external CPLD?  The registers are all defined as:
> >
> > +               .reg = reg_num + DREAM_CPLD_BASE,
> >
> > If they are external from the MSM chip this driver should probably be renamed
> > to something more appropriate since it is probably dream specific and not
> > generic to the msm architecture.
> 
> These are board specific gpios. I think it would be less confusing if
> the msm gpio support was added first.

I did not see msm-generic gpios in the trees, where are they? What is
connected over them?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
