Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0AVWp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0AVWp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169Ab0AVWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:45:57 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41804 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932131Ab0AVWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:45:56 -0500
Date: Fri, 22 Jan 2010 17:45:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device
 run-time PM (rev. 2)
In-Reply-To: <201001222156.25529.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001221740270.20253-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010, Rafael J. Wysocki wrote:

> > For example, we disable runtime PM for most USB devices by default.  
> > But a few drivers may know that their devices are able to handle it, so 
> > they want to change the default setting when they are bound.
> 
> Runtime PM is disabled for all devices by default unless the driver enables
> it.  The setting in power/control is to override the driver's choice, so that
> it can be disabled even if the driver tries to enable it.
> 
> IOW, the user space is the owner of the power.runtime_auto flag and I don't
> think we should allow drivers to modify it.

Okay, I understand your point of view.  It means I'll have to make some 
changes to the USB code.  No problem.

Alan Stern

