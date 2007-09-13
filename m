Return-Path: <linux-kernel-owner+w=401wt.eu-S1764881AbXIMWM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764881AbXIMWM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXIMWMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:12:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40960 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbXIMWMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:12:17 -0400
Date: Fri, 14 Sep 2007 00:13:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
Message-ID: <20070913221340.GA29181@uranus.ravnborg.org>
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913144228.2efcd5d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:42:28PM -0700, Andrew Morton wrote:
> On Thu, 06 Sep 2007 11:36:21 +0100
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Bernhard Walle wrote:
> > > This patch adds version information to the ELF kernel file. Together
> > > with the bzImage version information, this allows distributions to
> > > identify the kernel version based on the file name.
> > >   
> > 
> > Seems reasonable to me, but I think the macro could be just called
> > "ELFNOTE".
> > 
> 
> You removed Bernhard from the cc list.
> 
> I'd like to know a little bit more about why this is needed, how it will be
> used, etc.  And given that this feature is intended to improve life for
> distributors, it would be nice to get some feedback from the appropriate
> persons.
> 
> So could you please redo the patch as Jermey suggests (if you agree),
> revamp the description and then cc suitable people at suitable distros so
> we can get their input?

I would rather see allt this ELFNOTE stuff reverted.
It causes troubles for several archs and is at the moment
being discussed at arm-kernel for example.

Having it reverted and then applied when it is ready for all archs would
be preferred.

On top of this I never understood the actual purpose of it...

	Sam
