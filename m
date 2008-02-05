Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYBENZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYBENZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYBENZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:25:29 -0500
Received: from ns.suse.de ([195.135.220.2]:37778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYBENZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:25:29 -0500
Date: Tue, 5 Feb 2008 14:25:27 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: 2.6.24-mm1: ppc32: too few arguments to function
	'reserve_bootmem'
Message-ID: <20080205132526.GC31523@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	paulus@samba.org
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <200802042129.03065.m.kozlowski@tuxland.pl> <20080204144036.cf22a402.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204144036.cf22a402.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-02-04 23:40]:
> We did this wrong.  We should have introduced a new reserve_bootmem_foo()
> and migrated over to that in stages.  Once all callers are migrated, remove
> the old interface.

Well, my original proposal was to add a new function but then someone
complained that we already have too much bootmem functions. I don't
remember if this was on LKML or internally in Bugzilla.

However, sorry, it was my fault of course.


        Bernhard
