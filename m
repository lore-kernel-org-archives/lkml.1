Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZDUDDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZDUDDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZDUDD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:03:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44407 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZDUDDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:03:25 -0400
Date: Tue, 21 Apr 2009 12:01:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Wil" <nodenet@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: swap hint
Message-Id: <20090421120151.ae291dbd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BAY116-DAV13797E9A8B8D61B9322909B0760@phx.gbl>
References: <BAY116-DAV13797E9A8B8D61B9322909B0760@phx.gbl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 16:11:14 +0100
"Wil" <nodenet@hotmail.com> wrote:

> I've noticed that when running a VM such as qemu/vbox with approx 75% of
> physical memory allocated with the default swappiness the swap file usage
> will rise to approximately the same amount. Although setting swappiness to 0
> seems to prevent this, running with this setting seems counter intuitive.
> I'm wondering if the following is or would be possible
> 
> 1. Provide page hint to prevent swapping of certain pages. This would
> presumably allow applications running in the remaining host memory to use
> the swap file efficiently.
> 2. Provide user space controls to prevent a certain process (or the memory
> it allocates) being swapped. 
> 
> I'm not sure if memory ballooning will cover the above as I couldn't find
> details of anything similar but would think that having some tunability for
> special cases such as VMs would be useful especially if you could pick guest
> performance / host memory usage on a per VM basis. I note that xen does seem
> to do something along these lines as standard.
> 
> Will Wiseman
> 

Can't memory cgroup be a help for your case?

- Documentation/cgroup/memory.txt

Thanks,
-Kame

