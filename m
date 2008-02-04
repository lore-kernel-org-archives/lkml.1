Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYBDLD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYBDLD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYBDLDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:03:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48754 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBDLDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:03:17 -0500
Date: Mon, 4 Feb 2008 11:02:38 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: schwidefsky@de.ibm.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080204110238.GB2791@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	schwidefsky@de.ibm.com, benh@kernel.crashing.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20071112143009.425807965@de.ibm.com> <20071112144009.831296895@de.ibm.com> <20080201151541.8e3e0359.akpm@linux-foundation.org> <1202017020.7208.2.camel@pasglop> <20080202215315.3ac6907d.akpm@linux-foundation.org> <1202121409.31801.7.camel@localhost> <20080204025133.511ac3e2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204025133.511ac3e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 02:51:33AM -0800, Andrew Morton wrote:
> If this situation (conflicting changes and poor code quality) persists into
> the 2.6.25 cycle I will toss all the subsystem trees out of -mm, shall
> rebase -mm on mainline and shall merge first.  I had decided today to
> actually just do this, but on reflection I'll give it just one more shot.

Can I too whinge about that?

Shortly after the 2.6 merge window opened, various changes went in which
completely broke a number of the merged changes in the ARM tree.  That
resulted in the stuff which I thought was safe to merge becoming unsafe,
and with that I dropped all the changes which conflicted.

In some cases, these merge conflicts came about due to a bug fix I had
to put in to make the kernel bootable on ARM again.

I'm still in the middle of rebuilding the resulting mess from that - and
we're not yet back to where we were prior to the 2.6.24 release.  So, the
current version of the ARM tree which you most likely pulled for -mm1 is
incomplete with respect to what was planned to go in.  Therefore, you can
expect to see quite a number of apparantly "new" changes appearing in it
as these problems are resolved.

They're not really new, they're just the old stuff with the merge conflicts
fixed.

I don't see any end to these bun fights at the start of the merge window.
I believe it's inevitable given the work flow that we're now using.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
