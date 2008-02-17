Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYBQGc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYBQGc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYBQGcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:32:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52819 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYBQGcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:32:18 -0500
Date: Sat, 16 Feb 2008 22:32:00 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1
Message-ID: <20080217063200.GD26206@mail.oracle.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080217062540.GB26206@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217062540.GB26206@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 10:25:40PM -0800, Joel Becker wrote:
> On Sat, Feb 16, 2008 at 12:25:22AM -0800, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> ...
> > +avoid-divides-in-bits_to_longs.patch
> 
> Andrew,
> 	This patch, by introducing sizeof(long) in the BITS_TO_LONGS
> math, changes BITS_TO_LONGS from an int to a unsigned long.  We noticed
> because this printk in fs/ocfs2/dlm/dlmdomain.c:

	When building on x86_64.  I forgot that bit :-)

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
