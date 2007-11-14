Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXKNP3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXKNP3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXKNP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:29:21 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39440 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbXKNP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:29:20 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 10:29:19 EST
Date: Wed, 14 Nov 2007 08:20:58 -0700
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114152058.GE7523@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <p73sl39y6qb.fsf@bingen.suse.de> <20071114141751.GS17785@parisc-linux.org> <20071114143533.GF17145@one.firstfloor.org> <20071114150025.GU17785@parisc-linux.org> <20071114150801.GH17145@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114150801.GH17145@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org>:
> On Wed, Nov 14, 2007 at 08:00:25AM -0700, Matthew Wilcox wrote:
> > On Wed, Nov 14, 2007 at 03:35:33PM +0100, Andi Kleen wrote:
> > > It becomes much more when someone does a find /sys.
> > > dentries are expensive. They eventually can get pruned
> > > again, but it's still costly to do that.
> > 
> > Again, if this is a big concern for you, there are better
> > places to look at for savings.
> 
> Whoever is proposing a feature has the burden to justify that
> its usefulness is larger than the overhead/cost it adds.
> 
> Doesn't seem to be the case with this one so far.

I'm a bit confused where you're going with this. I thought the
main point of contention wasn't around the utility of the
patchset, it was around getting the actual information correct.

We've already mentioned several uses that this patchset adds:

  1. allowing managability folks to determine which physical slot
  their failing card might be sitting in (independent of hotplug
  capability).

  2. giving installers a method of presenting the physical slot
  to the user so that the user can choose to, say, do a network
  install off of the card in slot N, vs having to guess based on
  MAC address or something else unfriendly

  3. performance monitoring tools based on slot addresses/numbers

I believe that userspace cares more about those sorts of things
compared to consuming extra bytes when creating sysfs entries.

> And in general ignoring overhead in new features is a pretty
> sad approach. Big bloat does come in small steps with each new
> feature.

I'm kinda new to the Linux kernel, so I don't really get what
you're saying. Are you saying that the approved method of
exposing kernel information to the user via sysfs is actually
bloat? Even if that information has utility?

Feel free to educate me; I'm here to learn.

Thanks.

/ac

