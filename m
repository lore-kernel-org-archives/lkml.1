Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285Ab0AVWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0AVWz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213Ab0AVWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:55:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0AVWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:55:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device run-time PM (rev. 2)
Date: Fri, 22 Jan 2010 23:55:55 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1001221740270.20253-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001221740270.20253-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001222355.55676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 January 2010, Alan Stern wrote:
> On Fri, 22 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > For example, we disable runtime PM for most USB devices by default.  
> > > But a few drivers may know that their devices are able to handle it, so 
> > > they want to change the default setting when they are bound.
> > 
> > Runtime PM is disabled for all devices by default unless the driver enables
> > it.  The setting in power/control is to override the driver's choice, so that
> > it can be disabled even if the driver tries to enable it.
> > 
> > IOW, the user space is the owner of the power.runtime_auto flag and I don't
> > think we should allow drivers to modify it.
> 
> Okay, I understand your point of view.  It means I'll have to make some 
> changes to the USB code.  No problem.

Great, thanks a lot.

Rafael
