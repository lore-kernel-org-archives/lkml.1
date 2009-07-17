Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZGQVNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZGQVNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbZGQVNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:13:14 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58761 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbZGQVNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:13:13 -0400
Date: Fri, 17 Jul 2009 23:13:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       Paul Mundt <lethal@linux-sh.org>, Tony Luck <tony.luck@intel.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/2] linker script: unify usage of discard definition
Message-ID: <20090717211312.GD7080@merkur.ravnborg.org>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
	Paul Mundt <lethal@linux-sh.org>, Tony Luck <tony.luck@intel.com>,
	Mike Frysinger <vapier@gentoo.org>
References: <4A546646.70305@kernel.org> <4A546670.6070701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A546670.6070701@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 06:27:12PM +0900, Tejun Heo wrote:
> Discarded sections in different archs share some commonality but have
> considerable differences.  This led to linker script for each arch
> implementing its own /DISCARD/ definition, which makes maintaining
> tedious and adding new entries error-prone.
> 
> This patch makes all linker scripts to move discard definitions to the
> end of the linker script and use the common DISCARDS macro.  As ld
> uses the first matching section definition, archs can include default
> discarded sections by including them earlier in the linker script.
> 
> ia64 is notable because it first throws away some ia64 specific
> subsections and then include the rest of the sections into the final
> image, so those sections must be discarded before the inclusion.
> 
> defconfig compile tested for x86, x86-64, powerpc, powerpc64, ia64,
> alpha, sparc, sparc64 and s390.  Michal Simek tested microblaze.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Tested-by: Michal Simek <monstr@monstr.eu>
> Cc: linux-arch@vger.kernel.org
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Tony Luck <tony.luck@intel.com>

Patch looks good - thanks!

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
