Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZHLOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZHLOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZHLOFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:05:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:38266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZHLOFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:05:30 -0400
Date: Wed, 12 Aug 2009 07:07:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Dillow <dave@thedillows.org>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090812070759.2b9c1f32@infradead.org>
In-Reply-To: <20090812073152.GB28848@basil.fritz.box>
References: <20090805182805.GA7534@kroah.com>
	<20090805185136.GA21442@kroah.com>
	<87ljlxhrnr.fsf@basil.nowhere.org>
	<1249575658.19886.8.camel@lap75545.ornl.gov>
	<20090806183147.GA28409@suse.de>
	<1249772876.22248.34.camel@obelisk.thedillows.org>
	<20090810153943.GB7652@kroah.com>
	<1250001374.22248.65.camel@obelisk.thedillows.org>
	<20090811145523.GD14368@basil.fritz.box>
	<1250036727.26788.7.camel@obelisk.thedillows.org>
	<20090812073152.GB28848@basil.fritz.box>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 09:31:52 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > So use Eric/Arjan's program that does it in 60ms -- you get a
> > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> 
> That would likely need initrd at least on the distro I use which uses
> device files very early.

nah just need to call it early in /etc/rc.sysinit.

initrd is a read herring; distros don't need an initrd
(well except fedora who ship borken with a /dev without
even /dev/console)

initrd and /dev are not related concepts in that sense.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
