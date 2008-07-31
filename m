Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYGaP5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYGaP5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYGaP44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:56:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:9662 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYGaP4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J6lPuuMNmkDc7D1RAjFdK/MAVG8UPeegvvlYo5CNiuJk1sEwGL8g6M7hUuHFkdZm3G
         bgnObvCtqxw42Z0JRfKBNoesKnrKzUjwVa7jq/d4O2ZFovfNHm2NluXeHyl7fKkNIB/V
         84QwbPkHMA58PdongO4MKdJhs0KlPWai3nIQ0=
Date: Thu, 31 Jul 2008 11:56:48 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731115301.ZZRA012@mailhub.coreip.homeip.net>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080730231029.9818953c.akpm@linux-foundation.org> <20080731140708.GA11229@core.corenet.prv> <58cb370e0807310836x4a6e3c40rf5c3c8ec8b5caae0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb370e0807310836x4a6e3c40rf5c3c8ec8b5caae0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 05:36:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Thu, Jul 31, 2008 at 4:07 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Jul 30, 2008 at 11:10:29PM -0700, Andrew Morton wrote:
> >> On Wed, 30 Jul 2008 17:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>
> >> > I have created today's linux-next tree at
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> >>
> >> The X server broke on my FC8 t61p thinkpad.  Mainline is OK.
> >>
> >> Various information is at http://userweb.kernel.org/~akpm/mo/
> >>
> >> I'm suspecting the input layer - my synaptics device seems to have
> >> disappeared?  See http://userweb.kernel.org/~akpm/mo/Xorg-log-diff.txt
> >>
> >
> > I think this patch should help with Synaptics:
> 
> Which unfortunately doesn't help all people running with older synaptics
> user-space after commit 0571c5d20aca71c735222132b02aebddf593045c
> ("Input: expand keycode space").
> 
> Can't this be solved without breaking Xorg on newer kernels running
> older synaptics?
> 

No. The X driver is broken. It tells kernel to use buffer bugger than
allocated and gets its stack smashed. Tslib has also soma funkiness
in the ioctl handling as well... *shrug*

We have a couple months to get distros updated...

-- 
Dmitry
