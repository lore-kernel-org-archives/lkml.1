Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbXH1KWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbXH1KWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXH1KWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:22:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXH1KWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:22:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: Linux 2.6.23-rc4
Date: Tue, 28 Aug 2007 12:33:11 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org> <1188295796.4594.2.camel@localhost>
In-Reply-To: <1188295796.4594.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281233.11971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 August 2007 12:09, Soeren Sonnenburg wrote:
> On Mon, 2007-08-27 at 18:58 -0700, Linus Torvalds wrote:
> > Ok, I lost it, and let two weeks pass between -rc releases. My bad.
> > 
> > As a result, -rc4 is a bit bigger than it would/should have been, but 
> > hopefully it's all good, and we've fixed most regressions. There's some 
> > arch updates (MIPS, power, sparc64, s390) and an ACPI update, but the 
> > rest of it is mainly lots of small fixes (mostly to various random 
> > drivers). With some scheduler and networking noise.
> > 
> > I think the shortlog is _just_ too big to be posted on the kernel mailing 
> > list, but since it can mostly be described with the one word "boring", 
> > it's not a huge loss. As usual, just do
> > 
> > 	git shortlog v2.6.23-rc3..v2.6.23-rc4
> > 
> > if you have the git trees to get the all the details on extraneous 
> > semicolons, missed or duplicate include files, kzalloc conversions, new 
> > PCI ID's etc etc.
> 
> argh, something broke resume from s2ram on my mbp c1d... sometimes the
> machine resumes when opening the lid and then pressing the power button,
> but sometimes it is just dead (and it used to resume fine most of the
> time when *only* opening the lid).
> 
> I hope I find time to do a bisect soon...

Is this a regression from 2.6.23-rc3, or from an earlier kernel?

Rafael
