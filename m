Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYAGKAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYAGKAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYAGKAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:00:39 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:9193 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754125AbYAGKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:00:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vRyuV3dNBiF92Zu8B7evg0GwimvySdv1v3tNu14iMMuVaBaYlbVKquIsKLDdrqYGloRtHEVpKDD2RSRBHj+zlvrURrikNv9B6Y+2KMqEEhJYQ5YigibaEHdKKiXgztl89m6/3S9iMrqFGiBd/memH5480Ih0NRxko5jKhYoGBSw=
Message-ID: <a8e1da0801070200l6a8630f2td27f2f0b993cd4da@mail.gmail.com>
Date: Mon, 7 Jan 2008 18:00:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu,
       peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net,
       jarkao2@gmail.com, krh@redhat.com, dbrownell@users.sourceforge.net,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080107084528.GA8365@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	 <478120D9.5090404@s5r6.in-berlin.de>
	 <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	 <20080107084528.GA8365@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 4:45 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 07, 2008 at 10:09:44AM +0800, Dave Young wrote:
> >
> > Thanks for your comment, I rewrite it for 2.6.24-rc7 as a all-in-one
> > patch, please see following. Drop i2c maintainer and list in cc
> > because there's no changes about i2c in this patch:
> >
> > Convert semaphore to mutex in struct class
>
> Most of the non-driver core code should be converted to not use the
> lock in the class at all.  They should use a local lock instead.
>
> So how about a patch series that removes the usage of the current
> semaphore from the different drivers, and then, a single patch that
> converts the semaphore to mutex in the class code, it should not touch
> anything outside of the drivers/base/ directory (not including the
> driver.h file.)
>
> Sound reasonable?

looks like a better aproach, let me take a look ...

>
> thanks,
>
> greg k-h
>
