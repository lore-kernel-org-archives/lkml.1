Return-Path: <linux-kernel-owner+w=401wt.eu-S935400AbZLMCGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbZLMCGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935390AbZLMCGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:06:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40492 "HELO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935365AbZLMCF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:05:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 12 Dec 2009 23:40:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain> <200912122334.08367.rjw@sisk.pl>
In-Reply-To: <200912122334.08367.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912122340.24749.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Rafael J. Wysocki wrote:
> On Saturday 12 December 2009, Linus Torvalds wrote:
> > 
> > On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> > > 
...
> 
> > And no, making _everything_ be async is _not_ the answer.
> 
> I'm not sure what you mean, really.
> 
> Speaking of PCI bridges, even though they don't "suspend" in the sense of
> being put into low power states or something, we still need to save their
> registers on suspend and restore them on resume, and that restore has to
> be done before we start to access devices below the bridge.

Of course we restore them at the early stage now so the above remark does't
apply to the patch in question, sorry.

But the one below does.

> Even if we move that all to drivers, the constraints won't go away and someone
> will have to take care of them.  Now, since _we_ have problems with reaching
> an agreement about how to do it, the driver writers will be even less likely to
> figure that out.

Rafael
