Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZIJV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZIJV5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZIJV5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:57:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:52349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752979AbZIJV5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:57:30 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/QfqJvm5vQpp9i/bwjrwvWpceB5bg4diS47lrbAh
	upDxk/tmN1gRQz
From: Peter Huewe <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Date: Thu, 10 Sep 2009 23:57:27 +0200
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, Willy Tarreau <w@1wt.eu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20090903041429.GA29875@kroah.com> <20090905123951.GA1120@1wt.eu> <20090905145035.GA20698@kroah.com>
In-Reply-To: <20090905145035.GA20698@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909102357.27867.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Saturday 05 September 2009 16:50:35 schrieb Greg KH:
> On Sat, Sep 05, 2009 at 02:39:51PM +0200, Willy Tarreau wrote:
> > Hi Greg,
> >
> > On Wed, Sep 02, 2009 at 09:14:30PM -0700, Greg KH wrote:
> > > 	- panel.  Another one that should be simple to merge.  Anyone?
> >
> > I just got an email from a guy who proposed to work on it and who
> > showed me he's currently running tests and fixing a bug when removing
> > the module.
> >
> > Hopefully he'll make enough progress to get the driver merged.
> >
> > This proves that the principle of the staging tree seems to work,
> > and that your call was useful ;-)
>
> Glad to hear it!

yeah - Greg's call definitely was useful!
Although I'm still not sure if there is a point to getting the driver merged 
or not -- see discussion: "staging panel driver"
http://driverdev.linuxdriverproject.org/pipermail/devel/2009-September/001610.html

More opinions/suggestions are welcomed - especially from people who are more 
into lcdproc than I am.

However I'm currently working on it anyways - I already eliminated the bug:
while removing the module misc_deregister gets called twice (keypad and led - 
both twice) - once in the  panel_detach function and once in the 
panel_cleanup_module function.

And of course the second call fails :)
I will provide a (very simple :) patch to these issues tomorrow.



Thanks,
Peter
