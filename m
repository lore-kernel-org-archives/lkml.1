Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYKJIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYKJIYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYKJIYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:24:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53383 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYKJIYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:24:45 -0500
Date: Mon, 10 Nov 2008 17:24:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-Id: <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081110075529.GD707@atrey.karlin.mff.cuni.cz>
References: <20081109140726.GB1786@ucw.cz>
	<20081110075216.GD2093@elte.hu>
	<20081110075529.GD707@atrey.karlin.mff.cuni.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 08:55:29 +0100
Pavel Machek <pavel@suse.cz> wrote:

> > 
> > * Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> > > acpi_hibernation_leave, then SLAB corruption is detected and machine 
> > > ends in series of oops.
> > > 
> > > Any ideas how to debug that?
> > 
> > do you get any serial log or USB key output, so that it's debuggable 
> > directly?
> 
> Well, I can transcribe the BUG() from a picture, I guess, but it does
> not seem to contain much useful info: SLAB corruption was detected and
> backtrace is not quite important at that point...
> 
> Serial console is probably possible, but would take few days to setup.
> 									Pavel

How about this patch ?
==
http://marc.info/?l=linux-mm-commits&m=122624388629106&w=2
==

Thanks,
-Kame


