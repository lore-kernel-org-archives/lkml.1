Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYFKD5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYFKD5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYFKD5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:57:08 -0400
Received: from mail.tuxonice.net ([67.207.135.122]:55537 "EHLO
	mail.tuxonice.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYFKD5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:57:07 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [ANNOUNCE] linux-staging tree created
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080611032948.GB4483@kroah.com>
References: <20080610190540.GA25066@kroah.com>
	 <1213146346.16146.17.camel@nigel-laptop>  <20080611032948.GB4483@kroah.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Jun 2008 14:00:12 +1000
Message-Id: <1213156812.16146.37.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

On Tue, 2008-06-10 at 20:29 -0700, Greg KH wrote:
> On Wed, Jun 11, 2008 at 11:05:46AM +1000, Nigel Cunningham wrote:
> > Hi.
> > 
> > Would you consider including TuxOnIce in it?
> > 
> > I do still want to get it merged and would appreciate feedback.
> 
> Is the patch "stand-alone", only adding new code in discrete chunks like
> a new driver or filesystem would?

﻿The patch I distribute now does have a few parts to it that could be
separated into distinct patches (cryptoapi LZF support, fuse freezer
support), but the bulk of it is TuxOnIce itself, which just adds new
files and inserts the hooks necessary to share the lowlevel code with
[u]swsusp. I think, therefore, it would akin to adding a new driver or
filesystem.

> If not, I don't think it is relevant.  Odds are you want to be your own
> series of patches, like we discussed years ago, right?

I don't think I do want to have my own series of patches, because
TuxOnIce doesn't remove or rework swsusp or uswsusp, but sits along side
them. I'm not trying to mutate swsusp into TuxOnIce, because that would
require a complete rework of swsusp from the ground up (TuxOnIce does
everything but the atomic copy/restore ﻿and associated prep/cleanup
differently).

Regards,

Nigel

