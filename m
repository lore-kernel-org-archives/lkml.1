Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbXFSTBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbXFSTBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764472AbXFSTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:01:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:51134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764457AbXFSTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:01:45 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
References: <1182201271.4883.22.camel@localhost.localdomain>
	<20070618164711.9de1c38e.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jun 2007 21:57:44 +0200
In-Reply-To: <20070618164711.9de1c38e.akpm@linux-foundation.org>
Message-ID: <p73ps3rra2v.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> It seems too large.  Memory sizes are going up faster than disk throughput
> and it seems wrong to keep vast amounts of dirty data floating about in
> memory like this.  It can cause long stalls while the system writes back
> huge amounts of data and is generally ill-behaved.

A more continuous write out would be better I think. Perhaps the dirty ratio 
needs to be per address space?

> things are trivially tunable and you'd think that after all these years,
> distro initscripts would be establishing the settings, based upon expected
> workload, amount of memory, number and bandwidth of attached devices, etc.

Distro initscripts normally don't have any better clue about any of this
than the kernel.

-Andi
