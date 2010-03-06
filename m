Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0CFEQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 23:16:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53033 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751029Ab0CFEQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 23:16:21 -0500
Date: Fri, 5 Mar 2010 23:16:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       <linux-input@vger.kernel.org>, <linux-hotplug@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with remote-wakeup settings
In-Reply-To: <201003052304.49261.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1003052314130.10381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Rafael J. Wysocki wrote:

> On Friday 05 March 2010, Oliver Neukum wrote:
> > Am Freitag, 5. März 2010 21:59:31 schrieben Sie:
> > > > I guess it's better if drivers don't set should_wakeup if unsure, but of course
> > > > that's impossible to enforce.
> > > 
> > > That's the real question.  Ideally, drivers won't touch should_wakeup.  
> > > How do we get there from here?
> > 
> > Enable it only for devices specifically designed for wakeup, that is
> > keyboards, power buttons and WoL, perhaps also mice and modems.
> > Are we far away from that?
> 
> I don't think we're very far from that.
> 
> Mice are known dangerous, especially the USB ones, though.

I agree, especially for desktop systems.  You don't want the system to 
wake up merely because you happened to jostle the mouse.  That happened 
to me just a few days ago (and it was a PS/2 mouse, not USB).

Alan Stern

