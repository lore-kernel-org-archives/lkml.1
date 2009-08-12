Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZHLAEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZHLAEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 20:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZHLAEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 20:04:39 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51594 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZHLAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 20:04:39 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: Marcel Holtmann <marcel@holtmann.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Dillow <dave@thedillows.org>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
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
Date: Tue, 11 Aug 2009 17:04:19 -0700
Message-Id: <1250035459.30166.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

> > No, not really. It isn't hard to make a static /dev, or a rescue initrd
> > for the cases with dynamic device numbers.
> 
> There's a world between strictly controlled embedded and fully general
> distributions.
> 
> I want a dynamic /dev, but a fast one that doesn't need initrd or
> slows down booting.
> 
> This patch seems to be a good way to get that.

I fully agree.

And more important, if you don't like it, you don't have to use it. It
is just another filesystem and if you wanna stick with tmpfs that is
just fine, too :)

Regards

Marcel


