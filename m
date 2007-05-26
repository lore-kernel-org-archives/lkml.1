Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbXEZUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbXEZUSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbXEZUR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:17:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXEZUR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:17:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: software suspend doesn't work with 2.6.22-rc3
Date: Sat, 26 May 2007 22:23:39 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200705261128.57332.maxi@daemonizer.de> <1180178040.5493.5.camel@nigel.suspend2.net> <20070526115513.GA8230@gondor.apana.org.au>
In-Reply-To: <20070526115513.GA8230@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262223.39997.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 May 2007 13:55, Herbert Xu wrote:
> On Sat, May 26, 2007 at 09:14:00PM +1000, Nigel Cunningham wrote:
> > 
> > You have the cryptd Kconfig option in (at least in rc3) - presumably
> > Maximillian has been too keen and turned it on before you were ready :)
> > It does make sense for it to be the problem. Without PF_NOFREEZE set,
> > the refrigerator code will try to get it to enter the freezer, and
> > without the try_to_freeze(), it will just loop and freezing will fail.
> 
> OK that makes sense.  I'll apply your patch.

Please add '#include <freezer.h>' to crypto/cryptd.c for the patch to
compile.

FYI, I'm going to post a patch that will make this try_to_freeze() unnecessary,
but I don't think it'll make it into 2.6.22.

Greetings,
Rafael
