Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbXE3PLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbXE3PLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXE3PLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:11:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:32772 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXE3PLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:11:09 -0400
Date: Wed, 30 May 2007 17:12:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tej Parkash <tejparkash.d@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux-kernel-digest Digest, Vol 32, Issue 795
Message-ID: <20070530151209.GA15335@uranus.ravnborg.org>
References: <mailman.13746.1180510421.20629.linux-kernel-digest@lists.us.dell.com> <2bd9ebfa0705300735l51dcf4ceubf7f83ab44703010@mail.gmail.com> <2bd9ebfa0705300737t4f11ee71mca114b37a969db01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd9ebfa0705300737t4f11ee71mca114b37a969db01@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 08:07:53PM +0530, Tej Parkash wrote:
> On 5/30/07, Tej Parkash <tejparkash.d@gmail.com> wrote:
> >> > >
> >> > > while building module i was getting following warning and it 
> >terminate
> >> > > module building stage
> >> > The below are only warnings and your build should succeed.
> >> >
> >> > It is obviously i386 - is it a clean allmodconfig or any changes?
> >> > Is it latest -linus or some older version of the codebase?
> >> Did an allmodconfig build of i386 - I see (almost) all warnings here.
> >> So I will take a look based on this.
> 
> yaa i got the warning but as i said building stage is also getting
> terminated, without any error.
> 
> >The MODPOST stage took a while but it proceeded with no hick-ups.
> > MDOPSOT deals with ~2000 modules in my case and that consumes a bit
> > of memory. Maybe you are hitting the limit with respect to available RAM 
> > / SWAP?
> >
> >        Sam
> >
> >
> I don't think so that RAM or SWAP space is a constraint, is it related
> to kernel build option or some change in arch. config files
> I am not aware of the required patches for the same.
Can you please post relevant parts of a build with make V=2
That is the last couple of commands before the build suddenly stops.
Also to error-code reported by make must be included.

Ohh, and exact command-line + config you use.

	Sam
