Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZLIRKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZLIRKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZLIRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:10:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58845 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753683AbZLIRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:09:59 -0500
Date: Wed, 9 Dec 2009 12:10:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <20091209164653.GI9018@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.0912091204550.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mark Brown wrote:

> > How long does it take to bring down the entire embedded audio 
> > subsystem?  And how critical is the timing for typical systems?
> 
> Worst case is about a second for both resume and suspend which means two
> seconds total but it's very hardware dependant.  

A second seems awfully long.  What happens if audio isn't being played
when the suspend occurs?  Can't you shorten things with no artifacts in
that case?

If audio _is_ being played when a suspend occurs, users probably don't 
mind audible artifacts.  In fact, they probably expect some.

Alan Stern

