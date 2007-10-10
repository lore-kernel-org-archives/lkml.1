Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXJJQid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXJJQid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXJJQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:38:24 -0400
Received: from lixom.net ([66.141.50.11]:50826 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbXJJQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:38:23 -0400
Date: Wed, 10 Oct 2007 11:43:36 -0500
From: Olof Johansson <olof@lixom.net>
To: Milton Miller <miltonm@bga.com>
Cc: Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] powerpc: don't enable cpu hotplug on mpic-based
	pseries
Message-ID: <20071010164336.GA21507@lixom.net>
References: <20071010003824.GA8477@lixom.net> <200710101008.l9AA8hIG084068@sullivan.realtime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710101008.l9AA8hIG084068@sullivan.realtime.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 05:08:44AM -0500, Milton Miller wrote:
> Olof's patch searched the device-tree again, looking for an mpic.   This
> code instead checks that we found an xics the first time by checking the
> init function.

I'm glad you find the kernel so perfect that your best use of time is
to tweak the code added in a non-critical path (performance-wise) with
a new way of checking for hardware features (no other code in the kernel
checks ppc_md function pointers for that purpose).

Pseries can only have mpic or xics, so it's not like it matters if we
check for mpic or !xics, either.

But hey, any color bike shed will do, and I don't care which one Paul
chooses to merge. I will not waste more time debating this simple patch
though. :)


-Olof
