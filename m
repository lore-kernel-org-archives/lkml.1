Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbYHLE5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbYHLE5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYHLE5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:57:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYHLE5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:57:35 -0400
Date: Mon, 11 Aug 2008 21:56:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 1/2] mm owner fix race between swap and exit
Message-Id: <20080811215633.f8f5406d.akpm@linux-foundation.org>
In-Reply-To: <48A10C4C.6020009@linux.vnet.ibm.com>
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop>
	<20080811100733.26336.31346.sendpatchset@balbir-laptop>
	<20080811173138.71f5bbe4.akpm@linux-foundation.org>
	<48A10C4C.6020009@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 09:36:36 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > This patch applies to mainline, 2.6.27-rc2 and even 2.6.26.
> > 
> > Against which kernel/patch is it actually applicable?
> > 
> > (If the answer was "all of the above" then please don't go embedding
> > mainline bugfixes in the middle of a -mm-only patch series!)
> 
> Andrew,
> 
> The answer is all, but the bug is not exposed *outside* of the memrlimit
> controller, thus the push into -mm. I can redo and rework the patches for
> mainline if required and pull it out of -mm.

OK, I'll move it into the general MM patchpile for 2.6.28.  It will precede
any memrlimit merge.
