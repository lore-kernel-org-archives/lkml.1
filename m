Return-Path: <linux-kernel-owner+w=401wt.eu-S1946057AbXBPTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946057AbXBPTD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946056AbXBPTD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:03:28 -0500
Received: from mail.suse.de ([195.135.220.2]:53406 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946050AbXBPTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:03:27 -0500
To: fche@redhat.com (Frank Ch. Eigler)
Cc: Jeff Muizelaar <jeff@infidigm.net>, linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
References: <20070216013024.GA32287@infidigm.net>
	<y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Feb 2007 21:03:23 +0100
In-Reply-To: <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
Message-ID: <p73fy95g99w.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fche@redhat.com (Frank Ch. Eigler) writes:
> 
> We in systemtap land have the same problem, and so far made do with
> slightly postprocessed per-cpu TSC values.

90+% likely you're not solving your problem correctly this way.

-Andi
