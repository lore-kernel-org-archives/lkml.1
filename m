Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZAHWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZAHWv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763192AbZAHWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:50:56 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:44797 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763175AbZAHWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:50:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADMRZkl5LDnl/2dsb2JhbADPdoV1
X-IronPort-AV: E=Sophos;i="4.37,235,1231075800"; 
   d="scan'208";a="289379341"
Date: Fri, 9 Jan 2009 09:50:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
	while holding sb_lock
Message-ID: <20090108225050.GL9448@disturbed>
Mail-Followup-To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231429591.27353.14.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 09:46:31AM -0600, Dave Kleikamp wrote:
> sync_filesystems() shouldn't be calling async_synchronize_full_special
> while holding a spinlock.  The second while loop in that function is the
> right place for this anyway.

Out of curiousity, what on earth does
async_synchronize_full_special() do and why does it need to be in
sync_filesystems()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
