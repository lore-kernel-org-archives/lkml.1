Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZHLOOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZHLOOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZHLOOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:14:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbZHLOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:14:21 -0400
Date: Wed, 12 Aug 2009 16:14:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Dillow <dave@thedillows.org>,
       Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090812141421.GG28848@basil.fritz.box>
References: <87ljlxhrnr.fsf@basil.nowhere.org> <1249575658.19886.8.camel@lap75545.ornl.gov> <20090806183147.GA28409@suse.de> <1249772876.22248.34.camel@obelisk.thedillows.org> <20090810153943.GB7652@kroah.com> <1250001374.22248.65.camel@obelisk.thedillows.org> <20090811145523.GD14368@basil.fritz.box> <1250036727.26788.7.camel@obelisk.thedillows.org> <20090812073152.GB28848@basil.fritz.box> <20090812070759.2b9c1f32@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812070759.2b9c1f32@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 07:07:59AM -0700, Arjan van de Ven wrote:
> On Wed, 12 Aug 2009 09:31:52 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > So use Eric/Arjan's program that does it in 60ms -- you get a
> > > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> > 
> > That would likely need initrd at least on the distro I use which uses
> > device files very early.
> 
> nah just need to call it early in /etc/rc.sysinit.
> 
> initrd is a read herring; distros don't need an initrd
> (well except fedora who ship borken with a /dev without
> even /dev/console)

SUSE has the same problem. If the on disk /dev is empty
and it typically is out of the box then and there's no
initrd you don't boot.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
