Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbXGZAJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbXGZAJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXGZAJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:09:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:33026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbXGZAJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:09:25 -0400
Date: Wed, 25 Jul 2007 17:11:45 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs/udev broken in 2.6.23-rc1 [input, i2c, ...] (Was:
	sysfs/udev broken in latest git?)
Message-ID: <20070726001145.GC21056@suse.de>
References: <20070724072540.GA835@suse.de> <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com> <20070724084654.GB13152@suse.de> <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com> <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com> <46A628AC.3060900@simon.arlott.org.uk> <3ae72650707240934o68047677n97e6081ff3f42ce7@mail.gmail.com> <46A62F6A.8010403@simon.arlott.org.uk> <3ae72650707241719w6c7f2dc7s1bc29d7f1dfd4288@mail.gmail.com> <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725095808.09b2cc2a@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 09:58:08AM +0200, Cornelia Huck wrote:
> On Wed, 25 Jul 2007 02:19:18 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
> > > >> Removing the dev->parent->bus check fixes it:
> > 
> > Yes, let's remove the check, I will check now if we possibly need to
> > fix more than this or only the block-device patch.
> 
> It seems this is the only place we check for dev->parent->bus in the
> current git tree.
> 
> Patch below.

Thanks for figuring this out, I'll add this to my tree.

So what is the input layer doing so differently from everyone else here?
Is it correct?  (sorry, am at a conference this week, so can't dig into
it as much as I would like to until Friday...)

thanks,

greg k-h
