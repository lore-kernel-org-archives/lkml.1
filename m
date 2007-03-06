Return-Path: <linux-kernel-owner+w=401wt.eu-S934022AbXCFKdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbXCFKdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXCFKdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:33:38 -0500
Received: from p02c11o141.mxlogic.net ([208.65.145.64]:45910 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbXCFKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:33:23 -0500
Date: Tue, 6 Mar 2007 12:33:56 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306103356.GB4295@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain> <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 06 Mar 2007 10:36:01.0384 (UTC) FILETIME=[3C151680:01C75FDB]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15036.003
X-TM-AS-Result: No--7.216900-4.000000-31
X-Spam: [F=0.4999897002; S=0.499(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Linus Torvalds <torvalds@linux-foundation.org>:
>
> Ok, it does indeed solve the problem for me.

Not yet for me unfortunately, although this seems to help.
Is this the patch I should have applied?
http://lkml.org/lkml/2007/3/5/445

With this applied, on resume I get *some* screen output soon after resume
(e.g. with s2ram I get several characters on VGA, X starts drawing some windows)
but then the crescent symbol starts blinking again and the system hangs.

Could this be the ACPI problem Thomas mentions (acpi_processor_start is not called
when CPU#1 is resumed)?

-- 
MST
