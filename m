Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYDRJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYDRJGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYDRJGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:06:10 -0400
Received: from www.tglx.de ([62.245.132.106]:36487 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYDRJGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:06:09 -0400
Date: Fri, 18 Apr 2008 11:05:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] UBIFS - new flash file system
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
Message-ID: <alpine.LFD.1.10.0804181101000.3261@apollo.tec.linutronix.de>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Artem Bityutskiy wrote:
> UBIFS mount time is considerably faster as well. For example,
> In case of OLPC we observed 10-15 seconds faster boot time
> comparing to JFFS2 (fast mount, no full media check).

The mount time compared to JFFS2 on a 700MiB partition went down from
1min40s to 5sec on the same hardware. Pretty impressive
 
> UBIFS is quite complex because it is difficult to maintain
> indexing information on the flash media and be fast at the same
> time. Please, refer the UBIFS white paper for information
> about UBIFS design.

We did some initial stress tests and so far it looks pretty robust.

Great job !

Thanks,
	tglx
