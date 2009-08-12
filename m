Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHLAZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHLAZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 20:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZHLAZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 20:25:30 -0400
Received: from smtp.knology.net ([24.214.63.101]:54443 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZHLAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 20:25:30 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: David Dillow <dave@thedillows.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20090811145523.GD14368@basil.fritz.box>
References: <20090805171513.GA10443@kroah.com>
	 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	 <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
	 <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
	 <20090806183147.GA28409@suse.de>
	 <1249772876.22248.34.camel@obelisk.thedillows.org>
	 <20090810153943.GB7652@kroah.com>
	 <1250001374.22248.65.camel@obelisk.thedillows.org>
	 <20090811145523.GD14368@basil.fritz.box>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 20:25:27 -0400
Message-Id: <1250036727.26788.7.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 16:55 +0200, Andi Kleen wrote:
> > No, not really. It isn't hard to make a static /dev, or a rescue initrd
> > for the cases with dynamic device numbers.
> 
> There's a world between strictly controlled embedded and fully general
> distributions.

Sure, and I've acknowledged that. But it doesn't mean this needs a
kernel solution.

> I want a dynamic /dev, but a fast one that doesn't need initrd or
> slows down booting.

So use Eric/Arjan's program that does it in 60ms -- you get a
dynamic /dev, no initrd, fast boot, and no kernel changes required.

It remains to be seen how much it costs to do it in user space vs kernel
space. Arjan -- do you have a pointer to your program? Perhaps I can
shake loose some time to test that.

