Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab0BRR1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:27:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab0BRR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:27:49 -0500
To: Jerome Glisse <glisse@freedesktop.org>
Cc: hpa@zytor.com, suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       thellstrom@vmware.com, airlied@linux.ie, currojerez@riseup.net,
       linux-kernel@vger.kernel.org
Subject: Re: Uncool feature for TTM introduced by x86, pat: Use page flags to track memtypes of RAM pages
From: Andi Kleen <andi@firstfloor.org>
References: <20100218153032.GA4506@localhost.localdomain>
Date: Thu, 18 Feb 2010 18:27:39 +0100
In-Reply-To: <20100218153032.GA4506@localhost.localdomain> (Jerome Glisse's message of "Thu, 18 Feb 2010 16:30:32 +0100")
Message-ID: <87aav65u9g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse <glisse@freedesktop.org> writes:
>
> Can we modify the interface to support again changing from uc to wc
> or wc to uc ? (i can try to do a patch for that).

At least on Intel CPUs that support self-snoop (all modern
ones) that should really be very cheap.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
