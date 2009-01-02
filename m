Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZABWco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZABWco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZABWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:32:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51308 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZABWce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:32:34 -0500
Date: Fri, 2 Jan 2009 23:46:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [incremental-PATCH-for-Sam's-Review] ACPI: use ccflags-y instead of EXTRA_CFLAGS
Message-ID: <20090102224612.GE496@one.firstfloor.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org> <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <20081231133901.GB2388@uranus.ravnborg.org> <87bpusv31n.fsf@basil.nowhere.org> <20081231153441.GA3475@uranus.ravnborg.org> <alpine.LFD.2.00.0901021636050.3590@localhost.localdomain> <20090102215208.GA8494@uranus.ravnborg.org> <alpine.LFD.2.00.0901021709480.3590@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021709480.3590@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It appears that the entire kernel is now built with -Os by default,

It's default in defconfig, but not necessarily in all configs people
are using.

> so it looks like this is now redundant in the default case and will
> have an effect only when somebody disables CONFIG_CC_OPTIMIZE_FOR_SIZE
> to build with -O2.
> 
> So I'm willing to delete -Os from the ACPI Makefile
> in the interest of simplicity.

I would keep it. In fact it might make sense to expand explicit -Os
to more subsystems.

-Andi

-- 
ak@linux.intel.com
