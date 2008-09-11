Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYIKPZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYIKPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYIKPZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:25:48 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:4313 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYIKPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:25:48 -0400
From: Frans Pop <elendil@planet.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 17:24:59 +0200
User-Agent: KMail/1.9.9
References: <48C68507.6000609@suse.com> <200809111152.58187.elendil@planet.nl> <1221144627.8593.9.camel@macbook.infradead.org>
In-Reply-To: <1221144627.8593.9.camel@macbook.infradead.org>
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111725.01511.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 15:25:04.0005 (UTC) FILETIME=[905A4B50:01C91422]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, David Woodhouse wrote:
> > b) places a burden on the end-user to install/upgrade the firmware he
> >    needs separately from the kernel
>
> Not really. The new kernel package can just require the firmware
> package. There's not really much of a burden on the end-user, is there?

Did you read the second part of the mail explaining why having a 
single "firmware" package is not a good idea?
Also, if some firmware is assigned to non-free in Debian the kernel 
package CANNOT depend on it.

> > c) makes system installation more complex as the right additional
> > firmware package(s) need to be retrieved and installed
>
> It's a simple dependency, handled just like dependencies normally are
> -- it's not exactly a giant leap in complexity.

Nope, see above.

> > d) will break installed systems on upgrades (unless special measures
> > are taken): users may need to install additional firmware packages on
> > a kernel upgrade to keep a driver working
>
> I have yet to see reports of it breaking Fedora. You upgrade the
> kernel, the firmware package is automatically installed to satisfy the
> dependency. And it just works.

Nope, see above.

> Really, people seem to be imagining problems where they don't exist.

You have completely ignored my point in my other mail about 'make deb-pkg' 
being demonstrably broken as it results in packages that are guaranteed 
to produce file conflicts.
You have completely ignored my point about other existing packaging 
utilities being similarly broken.

Let me repeat again:
            THIS IS NOT ABOUT THE OFFICIAL DEBIAN PACKAGES

The Debian kernel team _will_ find a way to make this work properly. As 
far as separate firmware packages and upgrading is an issue the Debian 
project will deal with it, maybe using a userland "firmware-installer" 
tool or even if it is just by documenting the need to install firmware 
packages in the Release Notes.

This is about users, LIKE ME, being unable *NOW* to build correct custom 
kernel packages from upstream source *using existing tools*.
I am confronted with the broken packages as a result of your changes 
*every time I build/install a kernel* currently.

As you can see in other mail I'm currently working around it by using an 
extra option when installing the packages, but it's an option I should 
not have to use! And I'll probably change to just not building any 
drivers that need firmware at all as luckily none of my hardware needs 
in-tree firmware.

Sorry for all the emphasis, but it looks like you need it.
Your comments about how everything works for official Fedora package are 
completely irrelevant. Please try to look a bit further than your own 
narrow use-case.

I'm seriously disappointed with your reply.

Cheers,
FJP
