Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXCGA3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXCGA3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXCGA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:29:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030774AbXCGA3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:29:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 8136] 2.6.21-rc2-mm2 won't boot
Date: Wed, 7 Mar 2007 01:32:07 +0100
User-Agent: KMail/1.9.5
Cc: Nicolas.Mailhot@laposte.net, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
References: <200703062336.l26NaTZA026385@fire-2.osdl.org> <20070306161559.e0c7ee71.akpm@linux-foundation.org>
In-Reply-To: <20070306161559.e0c7ee71.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703070132.08217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 7 March 2007 01:15, Andrew Morton wrote:
> On Tue, 6 Mar 2007 15:36:29 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8136
> > 
> 
> Let's take this to email.
> 
> > 
> > 
> > 
> > ------- Additional Comments From Nicolas.Mailhot@LaPoste.net  2007-03-06 15:36 -------
> > Created an attachment (id=10631)
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=10631&action=view)
> > Printscreen with vesfg disabled and earlyprintk=vga
> > 
> 
> So rc2-mm2 panics due to "MP-BIOS bug: 8254 timer not connected to IO-APIC" and
> rc2-mm1 does not.

I'm observing a similar thing on my dual-core AMD64 testbed desktop.  Still,
another dual-core AMD64 machine I have runs -rc2-mm2 just fine.

One of the differences between them is that the failing one uses gcc 4.1.0 (sigh).

> Could be ACPI, could be x86_64 timer changes, could be something else.
> 
> Would you have time to bisect it? 
> http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt
> explains how.
> 
> If so, I'd suggest you drill in on the patches between
> x86_64-mm-defconfig-update.patch and
> optimize-and-simplify-get_cycles_sync.patch: the x86 changes.

I'll try to debug it tomorrow.

Greetings,
Rafael

-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
