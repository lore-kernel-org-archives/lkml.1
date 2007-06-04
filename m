Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXFDH7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXFDH7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 03:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXFDH7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 03:59:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbXFDH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 03:59:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: A kexec approach to hibernation
Date: Mon, 4 Jun 2007 10:05:41 +0200
User-Agent: KMail/1.9.5
Cc: vgoyal@in.ibm.com, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <20070604044041.GB10206@in.ibm.com> <1180934540.1169.31.camel@nigel.suspend2.net>
In-Reply-To: <1180934540.1169.31.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041005.42092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 4 June 2007 07:22, Nigel Cunningham wrote:
> Hi.
> 
> I can see that the idea of writing a kernel image from using another
> kernel sounds nice and clean initially, but the more we get into the
> details (yes, I am listening, even though I said nothing before now),
> the more it's sounding like the cure is worse than the disease.
> 
> To get rid of process freezing, we're talking about:
> * making hibernation depend on depriving the user of 32 or 64M of
> otherwise perfectly usable memory (thereby making hibernation on
> machines with less memory impossible)
> * requiring them to set up kexec or kdump (I don't understand the
> difference, sorry) or some new variation
> * adding interfaces to tell kexec/dump/whatever what pages need to be
> saved and reloaded
> * adding convolutions in which at resume time we boot one kernel, switch
> to another kernel to do the loading and then switch back again to the
> resumed kernel (assuming I understand what you're suggesting).
> 
> It all sounds terribly complicated and confusing to me, and that's
> before I even begin to think about how this second kernel could possibly
> write the image to an encrypted device or LVM or such like that the
> first kernel knows about and might use now.
> 
> Can't we just get the freezer right and be done with it?

My feelings about this are pretty much the same. :-)

At least, there still is room for improvements within the current approach,
so first I'd like to improve it as much as reasonably possible and then to
think of alternatives, if need be.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
