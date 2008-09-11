Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYIKQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYIKQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYIKQQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:16:09 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35630 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYIKQQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:16:08 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: davem@davemloft.net, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <200809111058.42362.elendil@planet.nl>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
	 <20080910.162423.40167601.davem@davemloft.net>
	 <1221119068.6309.8.camel@californication>
	 <200809111058.42362.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:16:37 +0200
Message-Id: <1221149797.6309.37.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

> > it is that the Debian maintainer screwed this up.
> 
> WRONG! NOT TRUE! FUD!
> The Debian maintainer has done nothing of the kind.
> 
> > To shed some light into the problem with Debian/Ubuntu. They install the
> > firmware in /lib/firmware/`uname -r`/
> 
> Debian does no such thing! It may be that Ubuntu does this, but that does 
> NOT mean that Debian does too.

I apologize for this. You are absolute right. Debian does the correct
thing and only Ubuntu made this a problem.

> > Problem comes when installing let say 2.6.27 since then the firmware
> > will be looked up in /lib/firmware/ and /lib/firmware/2.6.27/ and
> > actually it will not be found. Since it is in /lib/firmware/2.6.26-xx/
> > or something similar.
> > 
> > So having the kernel install everything in /lib/firmware works just fine
> > with every distro. However looking for firmware that is not shipped with
> > the kernel, we have a problem since Debian/Ubuntu just not installs it
> > in the right directory. And there is nothing the kernel can do about it
> > since it will not touch firmware it doesn't ship. The distro has to fix
> > their firmware or the users have to place a copy in /lib/firmware/ where
> > it actually should have been in the first place.
> 
> This is a ridiculously simplified view of the issue. Why can't you at 
> least acknowledge that people were faced with a real problem _without_ 
> proper guidance, support or transition path from their upstream source 
> and made their best effort to solve that issue.

That is just plain naive on the package maintainer side. If the package
maintainer has to solve problems, then contacting upstream should be the
first thing to do. I might be wrong here, but I don't recall any
requests like this on LKML or linux-hotplug. They just did it their way
without contacting either kernel guys or udev people.

Regards

Marcel


