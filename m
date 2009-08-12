Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZHLM4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZHLM4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZHLM4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:56:54 -0400
Received: from smtp.knology.net ([24.214.63.101]:56776 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZHLM4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:56:54 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: David Dillow <dave@thedillows.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20090812003433.GA25392@kroah.com>
References: <20090805182805.GA7534@kroah.com>
	 <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
	 <20090806183147.GA28409@suse.de>
	 <1249772876.22248.34.camel@obelisk.thedillows.org>
	 <20090810153943.GB7652@kroah.com>
	 <1250001374.22248.65.camel@obelisk.thedillows.org>
	 <20090811145523.GD14368@basil.fritz.box>
	 <1250036727.26788.7.camel@obelisk.thedillows.org>
	 <20090812003433.GA25392@kroah.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 08:56:53 -0400
Message-Id: <1250081813.26788.13.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 17:34 -0700, Greg KH wrote:
> On Tue, Aug 11, 2009 at 08:25:27PM -0400, David Dillow wrote:
> > So use Eric/Arjan's program that does it in 60ms -- you get a
> > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> 
> Their program only handles it for a reconstruction of /dev based on
> sysfs one time at boot.  It does not handle things that are added or
> discovered by the system after that, you need udev for that.
> 
> So it's a great hack for boot time stuff, but not a complete /dev
> management replacement like this code can be for numerous systems.

What systems would those be? Perhaps it's just too early in the morning
for me, but I'm having a hard time thinking of ones that wouldn't want
to use udev in that case for the event notification, or have their own
handler, such as an embedded system.

