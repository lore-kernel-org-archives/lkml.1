Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXKNPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXKNPIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXKNPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:08:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53117 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXKNPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:08:05 -0500
Date: Wed, 14 Nov 2007 16:08:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alex Chiang <achiang@hp.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114150801.GH17145@one.firstfloor.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <p73sl39y6qb.fsf@bingen.suse.de> <20071114141751.GS17785@parisc-linux.org> <20071114143533.GF17145@one.firstfloor.org> <20071114150025.GU17785@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114150025.GU17785@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 08:00:25AM -0700, Matthew Wilcox wrote:
> On Wed, Nov 14, 2007 at 03:35:33PM +0100, Andi Kleen wrote:
> > It becomes much more when someone does a find /sys. dentries are 
> > expensive. They eventually can get pruned again, but it's still
> > costly to do that.
> 
> Again, if this is a big concern for you, there are better places to look
> at for savings.

Whoever is proposing a feature has the burden to justify that
its usefulness is larger than the overhead/cost it adds.

Doesn't seem to be the case with this one so far.

And in general ignoring overhead in new features is a pretty sad
approach. Big bloat does come in small steps with each new feature.

-Andi
