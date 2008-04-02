Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYDBOZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYDBOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYDBOZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:25:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753067AbYDBOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:25:15 -0400
Date: Wed, 2 Apr 2008 10:25:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Pavel Machek <pavel@ucw.cz>, <linux-usb@vger.kernel.org>,
       Soeren Sonnenburg <sonne@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core
 Duo
In-Reply-To: <20080401210617.GA7346@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0804021004001.14858-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Tino Keitel wrote:

> > Network console?  SSH?  Or even telnet?
> 
> Network is dead, too.

Okay, then try this.  Boot with "no_console_suspend" on the command
line.  Do "echo devices >/sys/power/pm_test" before starting the
suspend.  Then "echo mem >/sys/power/state", and while the system is
paused try unplugging/replugging a USB device.

Maybe that will provide usable information.

Alan Stern

