Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXHVKL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXHVKL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbXHVKLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:11:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXHVKLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:11:21 -0400
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: huge improvement with per-device dirty throttling
References: <1187764638.6869.17.camel@hannibal>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Aug 2007 13:05:13 +0200
In-Reply-To: <1187764638.6869.17.camel@hannibal>
Message-ID: <p733aybzv6e.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jeffrey W. Baker" <jwbaker@acm.org> writes:
> 
> My system is a Core 2 Duo, 2GB, single SATA disk.

Hmm, I thought the patch was only supposed to make a real difference
if you have multiple devices? But you only got a single disk.   

At least that was the case  it was supposed to fix: starvation of fast 
devices from slow devices.

Ok perhaps the new adaptive dirty limits helps your single disk
a lot too. But your improvements seem to be more "collateral damage" @)

But if that was true it might be enough to just change the dirty limits
to get the same effect on your system. You might want to play with
/proc/sys/vm/dirty_*

-Andi

