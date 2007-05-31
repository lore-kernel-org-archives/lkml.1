Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbXEaT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbXEaT5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761654AbXEaT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:57:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761473AbXEaT5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:57:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Thu, 31 May 2007 22:02:53 +0200
User-Agent: KMail/1.9.5
Cc: nigel@nigel.suspend2.net, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <200705310744.44488.rjw@sisk.pl> <20070531142357.GK27309@elf.ucw.cz>
In-Reply-To: <20070531142357.GK27309@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705312202.53945.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, 31 May 2007 16:23, Pavel Machek wrote:
> Hi!
> 
> > > > I'll post revised patches in a new thread.
> > > 
> > > I haven't been giving this much attention, so forgive me if I'm about to
> > > ask a silly question... which notifiers would you see the avenrun
> > > saving/restoring using?
> > 
> > I'm not sure what you mean.  Could you please clarify?
> 
> Remember that patch about saving/restoring "load average"? I guess
> Nigel asks where to hook it.

Ah, okay, thanks.

Hmm, that would be PM_PRE_HIBERNATION, I think.

Rafael
