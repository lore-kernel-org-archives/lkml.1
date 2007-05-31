Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXEaFhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXEaFhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 01:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXEaFg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 01:36:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46399 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXEaFg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 01:36:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Thu, 31 May 2007 07:42:20 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <200705302311.40123.rjw@sisk.pl> <20070530222956.GD27309@elf.ucw.cz>
In-Reply-To: <20070530222956.GD27309@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310742.21852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 May 2007 00:29, Pavel Machek wrote:
> Hi!
> 
> > > I think the rule should be: If you need to do something _before_ tasks are
> > > frozen, do it in PM_PRE_FREEZE, but if you can do that after the tasks have
> > > been frozen, do it on PM_HIBERNATION_PREPARE (or PM_SUSPEND_PREPARE in the
> > > suspend case).
> > 
> > OTOH, having considered it for a while, I think that for now I can add just
> > PM_PRE_FREEZE and PM_POST_THAW, as I don't have any user for the other ones.
> > The other events may be added in the future if need be (along with some users).
> > 
> > I'll post revised patches in a new thread.
> 
> Yes please.
> 
> (Hmm, but you may create 4 of them PM_PRE_HIBERNATION, PM_PRE_SUSPEND,
> PM_POST_HIBERNATION, PM_POST_SUSPEND -- I'd call all of them before
> freeze and after thaw, but if we drop freezer for suspend, we won't
> have to rename anything.)

Yes, that's a good idea. :-)

Greetings,
Rafael
