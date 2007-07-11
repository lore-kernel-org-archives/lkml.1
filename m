Return-Path: <linux-kernel-owner+w=401wt.eu-S1763670AbXGKN3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763670AbXGKN3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbXGKN3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:29:42 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43953 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbXGKN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:29:41 -0400
Date: Wed, 11 Jul 2007 14:28:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Message-ID: <20070711132819.GA5753@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.36027.rjw@sisk.pl> <20070709132905.GA5212@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709132905.GA5212@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: sysrq-t dumps of s2ram/fuse deadlock (was Re: [PATCH] Remove process freezer from suspend to RAM pathway)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 01:29:05PM +0000, Pavel Machek wrote:
> Hi!
> 
> Can we get them? They are neccessary for debugging 'what in suspend
> calls fuse' problem. And yes, that problem is there even when you
> remove freezer.

I can produce them, but haven't managed to do that in any way that lets 
me get them off the system yet.

> Matthew, you seem to be the only one able to produce them...

sys_sync may not do anything on a fuse filesystem, but if you've 
loopback-mounted an ext3 filesystem from that fuse filesystem then it's 
going to result in writes to it and deadlock.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
