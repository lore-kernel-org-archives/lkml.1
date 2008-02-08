Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbYBHQZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbYBHQZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYBHQYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:24:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbYBHQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:24:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 17:23:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <47AB975C.1010902@zytor.com> <20080208070419.GA4544@ucw.cz>
In-Reply-To: <20080208070419.GA4544@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081723.16354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Pavel Machek wrote:
> Hi!

Hi,

> > >I really need the entry point to be at offset 0, so 
> > >that I can get
> > >pointers to my data. I could not figure out how to do 
> > >it any other
> > >way. And if 0 is taken, I thought I'd put header at the 
> > >end.
> > >
> > 
> > Why not just put the structure at 0, and put pointers in 
> > the structure to everything else you need?
> 
> segments:offsets rear its ugly head here. I need %ds to point to my
> data, and the way to do it is copy it from %cs; that needs start to be
> at 0.

Hm, why exactly is that necessay?

Rafael
