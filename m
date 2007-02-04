Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXBDRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXBDRHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXBDRHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:07:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:24590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXBDRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=brrPD4rp/preGQGmVENEhnhd38LCKsJncQF9p6T93M3y+lsE8GwVo4MVpKR4n0QWtqbNh8r6FDS7MbpYq+mPS1HDUwlziv+yTMIaJszqFzOKnCfj0z9NGVLAdmcbRVLchP5sMu47Akt9SYKtAXEZY5pk1+NM7YmQSkfiQOv0sKk=
Message-ID: <195c7a900702040907y8b8eff0gc8b0bbddd79a6792@mail.gmail.com>
Date: Sun, 4 Feb 2007 18:07:46 +0100
From: "roucaries bastien" <roucaries.bastien@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Bcm43xx oops after suspend to disk
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "bcm43xx devel" <Bcm43xx-dev@lists.berlios.de>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <45BE1639.6040106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net>
	 <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>
	 <45BA246B.6030505@lwfinger.net> <20070129115842.GA4928@ucw.cz>
	 <195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com>
	 <20070129140408.GA19379@srcf.ucam.org> <45BE1639.6040106@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Matthew Garrett wrote:
> > On Mon, Jan 29, 2007 at 01:55:41PM +0100, roucaries bastien wrote:
> >> -       return 0;
> >> +       return bcm43xx_init_one(pdev, NULL);
> >> }
> >
> > While this may well work (it's basically equivalent to unloading and
> > reloading the module), it's not a long-term fix - userspace is going to
> > notice the interface vanishing and reappearing. Larry, I guess you just
> > mean this as a test patch?
> >
>
> Yes. If this doesn't work, then we have real problems. If it does, then I try to find the part that
> is missing in the current code.

Sorry for the delay it works. This time I can use iwlist eth scan.
I have some difficulties to associate and I need to rmmod/modprobe in
order to associate but it is another problem linked to a really weak
power.

Another good point is:
- before path : wifi link led is off before suspend and on after
- after patch: wifi link led is always off.
Initialisation problem?

I will send you dmesg by private mail.

Regards bastien
> Larry
>
>
