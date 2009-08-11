Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZHKOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZHKOz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZHKOz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:55:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37290 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZHKOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:55:26 -0400
Date: Tue, 11 Aug 2009 16:55:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Dillow <dave@thedillows.org>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090811145523.GD14368@basil.fritz.box>
References: <20090805171513.GA10443@kroah.com> <20090805192037.19c54c4d@lxorguk.ukuu.org.uk> <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com> <87ljlxhrnr.fsf@basil.nowhere.org> <1249575658.19886.8.camel@lap75545.ornl.gov> <20090806183147.GA28409@suse.de> <1249772876.22248.34.camel@obelisk.thedillows.org> <20090810153943.GB7652@kroah.com> <1250001374.22248.65.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250001374.22248.65.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, not really. It isn't hard to make a static /dev, or a rescue initrd
> for the cases with dynamic device numbers.

There's a world between strictly controlled embedded and fully general
distributions.

I want a dynamic /dev, but a fast one that doesn't need initrd or
slows down booting.

This patch seems to be a good way to get that.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
