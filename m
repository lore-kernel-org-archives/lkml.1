Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZHLRAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZHLRAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZHLRAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:00:04 -0400
Received: from emroute4.ornl.gov ([160.91.86.27]:46354 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbZHLRAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:00:03 -0400
X-Greylist: delayed 3778 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 13:00:03 EDT
Date: Wed, 12 Aug 2009 11:57:00 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
In-reply-to: <20090812152623.GB29407@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Arjan van de Ven <arjan@infradead.org>
Message-id: <1250092620.12316.9.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20090806183147.GA28409@suse.de>
 <1249772876.22248.34.camel@obelisk.thedillows.org>
 <20090810153943.GB7652@kroah.com>
 <1250001374.22248.65.camel@obelisk.thedillows.org>
 <20090811145523.GD14368@basil.fritz.box>
 <1250036727.26788.7.camel@obelisk.thedillows.org>
 <20090812003433.GA25392@kroah.com>
 <1250081813.26788.13.camel@obelisk.thedillows.org>
 <20090812134440.GA28839@kroah.com>
 <1250087997.8566.9.camel@obelisk.thedillows.org>
 <20090812152623.GB29407@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 08:26 -0700, Greg KH wrote:
> On Wed, Aug 12, 2009 at 10:39:57AM -0400, David Dillow wrote:
> > Rescue disks may be an exception, but they only need a minimal
> > static /dev and then run a tool to get the initial setup. If you are
> > expecting an expert to use them, then either running the tool by hand or
> > as a post-modprobe rule should catch updates. They can also run udev (or
> > a replacement) with stripped rules if you want to make it friendlier to
> > non-expert users.
> 
> Ok, so don't use devtmpfs on your rescue disk, let the rest of us have a
> choice :)

But you have a choice, patch your local kernel. ;)

While my opinion doesn't carry as much weight as yours, Alan's, or
Arjan's, I'm "meh" on this patch. I'm not dead set against it going in,
nor have I seen a compelling reason to do something in kernel space that
can be readily done in user space.
