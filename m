Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbZHLMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbZHLMuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZHLMuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:50:50 -0400
Received: from smtp.knology.net ([24.214.63.101]:33425 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZHLMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:50:49 -0400
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
In-Reply-To: <20090812073152.GB28848@basil.fritz.box>
References: <20090805182805.GA7534@kroah.com>
	 <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
	 <20090806183147.GA28409@suse.de>
	 <1249772876.22248.34.camel@obelisk.thedillows.org>
	 <20090810153943.GB7652@kroah.com>
	 <1250001374.22248.65.camel@obelisk.thedillows.org>
	 <20090811145523.GD14368@basil.fritz.box>
	 <1250036727.26788.7.camel@obelisk.thedillows.org>
	 <20090812073152.GB28848@basil.fritz.box>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 08:50:46 -0400
Message-Id: <1250081446.26788.9.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 09:31 +0200, Andi Kleen wrote:
> > So use Eric/Arjan's program that does it in 60ms -- you get a
> > dynamic /dev, no initrd, fast boot, and no kernel changes required.
> 
> That would likely need initrd at least on the distro I use which uses
> device files very early.

Or mount a tmpfs on /dev and run it right after you mount /proc
and /dev. Doesn't need an initrd.

