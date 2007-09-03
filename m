Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbXICPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbXICPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 11:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXICPZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 11:25:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbXICPZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 11:25:17 -0400
Date: Mon, 3 Sep 2007 11:24:57 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: colin.michael@o2online.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] enable userspace cpu core voltage control with
	acpi-cpufreq
Message-ID: <20070903152457.GC21586@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, colin.michael@o2online.de,
	linux-kernel@vger.kernel.org
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de> <p738x7oaugi.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p738x7oaugi.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 12:56:13PM +0200, Andi Kleen wrote:
 > <colin.michael@o2online.de> writes:
 > 
 > > i want to make a patch known that provides a userspace interface to control the core voltage of a computer processor(s).
 > 
 > That would be essentially linux supported undervolting which 
 > for stability is as bad as overclocking. The problem is that 
 > such games tend to generate weird kernel crashes and then
 > chew up development issues when kernel hackers have to chase
 > ghost bugs. I don't think we should support it. Developer 
 > time is too precious.
 
Seconded.  Exactly the same reasons I've refused to merge patches
into cpufreq to allow arbitrary tables to override BIOS tables.
Or patches to remove boundary checks.   Even when correctly
implemented, this stuff can be fragile as hell, so introducing
more things that cast doubt over its stability isn't something
I'm keen on at all.

	Dave

-- 
http://www.codemonkey.org.uk
