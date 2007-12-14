Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXLNULj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXLNULj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXLNULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:11:32 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4894 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXLNULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:11:31 -0500
Subject: Re: [PATCH] printk_ratelimit functions should use CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071214191215.GI19691@waste.org>
References: <1197658835.4861.45.camel@localhost>
	 <20071214191215.GI19691@waste.org>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 12:11:13 -0800
Message-Id: <1197663073.4861.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-14 at 13:12 -0600, Matt Mackall wrote:
> On Fri, Dec 14, 2007 at 11:00:35AM -0800, Joe Perches wrote:
> > Makes an embedded image a bit smaller
> 
> Looks good to me. This should probably go to Andrew first though. And
> it wouldn't hurt to see some size(1) results.

For instance:

x86 32 Allnoconfig, CONFIG_EMBEDDED=y CONFIG_PRINTK not set

with:

$ size -A vmlinux

vmlinux  :
section                      size         addr
.text                      697864   3222274240
.rodata                    121988   3222974464
.data                       75952   3223097344
.bss                        69632   3223289856
Total                     1095589

without:

$ size -A vmlinux
vmlinux  :
section                      size         addr
.text                      698376   3222274240
.rodata                    122032   3222978560
.data                       76080   3223101440
.bss                        69632   3223298048
Total                     1096273


