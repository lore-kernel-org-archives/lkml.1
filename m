Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYFYBdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYFYBdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFYBc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:32:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47977 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808AbYFYBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:32:56 -0400
Date: Tue, 24 Jun 2008 20:32:52 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080624203252.f932c631.pj@sgi.com>
In-Reply-To: <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	<20080623060939.6b6b3183.pj@sgi.com>
	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> Zone PFN ranges:
>   DMA      0x       0 -> 0x    1000

Aha - you're right!

I just earned the Ugly Patch of the Day Award.

I think changes of "%lu" to "0x%lx" are still ok,
but changes of "%8lu" to "0x%8lx" (which use 8
columns, right aligned, space filled format) are
not ok.

I will redo this patch, without the "0x" prefix
on the space filled fields.  Let me know if that
is better.

Thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
