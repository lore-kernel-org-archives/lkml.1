Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZFPIQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZFPIQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFPIPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:15:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZFPIPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:15:43 -0400
Date: Tue, 16 Jun 2009 10:15:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <1245083361.6821.1.camel@localhost>
Message-ID: <alpine.LNX.2.00.0906161014550.7457@wotan.suse.de>
References: <1244996001.8440.10.camel@localhost>  <200906142031.38358.elendil@planet.nl> <1245006429.23043.2.camel@localhost>  <200906142129.08135.rjw@sisk.pl>  <alpine.LNX.2.00.0906142246120.7457@wotan.suse.de> <1245083361.6821.1.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Thomas Meyer wrote:

> > > As for the mouse itself, I don't know.  I'm not even sure if it's 
> > > possible at all (CCing Jiri).
> > The main question is whether the mouse really is generating wakeup event 
> > even if unused.
> > Could you please provide usbmon dumps (Documentation/usb/usbmon.txt) from 
> > the failing suspend session?
> I tried and usbmon seems to kill my machine. See attached screenshot.

Unfortunately the trace is far from being complete -- most importantly, 
the first lines of the oops/BUG are missing. Is there any chance you could 
either set up a serial console, or choose a smaller console font, to catch 
the whole thing?

Thanks,

-- 
Jiri Kosina
SUSE Labs
