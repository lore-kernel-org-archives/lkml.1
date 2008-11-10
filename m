Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYKJMAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYKJMAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYKJMAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:00:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55554 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbYKJMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:00:07 -0500
Date: Mon, 10 Nov 2008 09:27:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110082749.GA1969@elf.ucw.cz>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu> <20081110075529.GD707@atrey.karlin.mff.cuni.cz> <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110172407.5584156d.kamezawa.hiroyu@jp.fujitsu.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-10 17:24:07, KAMEZAWA Hiroyuki wrote:
> On Mon, 10 Nov 2008 08:55:29 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > 
> > > * Pavel Machek <pavel@suse.cz> wrote:
> > > 
> > > > ...at least on 2.6.27 and 2.6.28-rc3. Resume gets to 
> > > > acpi_hibernation_leave, then SLAB corruption is detected and machine 
> > > > ends in series of oops.
> > > > 
> > > > Any ideas how to debug that?
> > > 
> > > do you get any serial log or USB key output, so that it's debuggable 
> > > directly?
> > 
> > Well, I can transcribe the BUG() from a picture, I guess, but it does
> > not seem to contain much useful info: SLAB corruption was detected and
> > backtrace is not quite important at that point...
> > 
> > Serial console is probably possible, but would take few days to setup.
> 
> How about this patch ?
> ==
> http://marc.info/?l=linux-mm-commits&m=122624388629106&w=2
> ==

Yep, that one is neccessary to get that far... yes, I have it applied.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
