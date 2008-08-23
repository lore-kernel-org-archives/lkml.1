Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYHWUE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYHWUE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYHWUEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:04:48 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:14879 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYHWUEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:04:47 -0400
Date: Sat, 23 Aug 2008 14:04:46 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080823200446.GA24936@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>,
	Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com> <20080823154450.GA27985@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823154450.GA27985@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com>:
> On Fri, Aug 22, 2008 at 01:53:58PM -0600, Alex Chiang wrote:
> > 
> > Does anyone have numbers for how much it costs to create a new
> > symlink? I could try and figure this out but it will take a few
> > days (busy with other stuff).
> 
> Almost nothing.
> 
> sysfs creates these things on the fly as they are accessed, and if
> memory pressure on the machine happens, they are freed up properly and
> then created again if a user asks to see them in the tree.
> 
> So don't worry about memory issues when adding new files or symlinks in
> sysfs, it just isn't a problem (we handle 20000 disks easily on low
> memory 31bit s390 systems.)

Great, thanks for the explanation.  I've heard the "memory
overhead" argument before for not wanting to create other sysfs
files/links, so this will be good to debunk that bogeyman if it
pops up again in the future.

Did you get a chance to take a look at the documentation I wrote
for these new symlinks? [I also went and documented the existing
slots/ directory as well...]

Was it what you had in mind?

Thanks.

/ac

