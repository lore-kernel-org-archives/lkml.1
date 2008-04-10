Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYDJW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYDJW2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYDJW2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:28:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50561 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbYDJW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:28:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: x86 git tree broken
Date: Fri, 11 Apr 2008 00:28:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <20080410202914.GD9582@elte.hu> <20080410203800.GA14560@elte.hu>
In-Reply-To: <20080410203800.GA14560@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804110028.22290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of April 2008, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > > First, the X server doesn't want to start (it says it couldn't 
> > > > > mmap the framebuffer).
> > > > 
> > > > could you send your .config?
> > > 
> > > Attached.
> > 
> > could you disable this option:
> > 
> >  CONFIG_NONPROMISC_DEVMEM=y
> > 
> > does it help with the X problem?

That didn't help.

> btw., Xorg works fine here on a comparable AMD system - but i use a 
> rather new distro (Fedora 8) which has Xorg 7.2.

My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.

I think the problem is somehow related to the Radeon.

Thanks,
Rafael
