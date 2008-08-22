Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYHVOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYHVOBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYHVOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:01:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:44136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYHVOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:01:03 -0400
Date: Fri, 22 Aug 2008 07:00:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080822070054.5d466be9@infradead.org>
In-Reply-To: <20080819210932.9bb348b9.akpm@linux-foundation.org>
References: <20080815152938.4bc9d48c@infradead.org>
	<20080819210932.9bb348b9.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 21:09:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> If we remove the first two checks then surely we can afford to add the
> remaining check unconditionally and lose the new config option and its
> ifdef.
> 

Andi told me that this notifier is a hotpath for kprobes (systemtap)
use models; at which point making this a config option makes sort of
sense to get the last bit of performance out of that. Personally I would
always want this option on for anything I run, and I suspect
(enterprise) distros will just always turn it on as well since it's a
good sanity check at low cost.

I'd be happy to lose the config (I think we have way too many unneeded
ones of those already); I'll make a patch.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
