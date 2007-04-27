Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXD0Dhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXD0Dhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXD0Dhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:37:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbXD0Dhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:37:45 -0400
Date: Thu, 26 Apr 2007 20:36:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Williams <pwil3058@bigpond.net.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
In-Reply-To: <463166C2.6060106@bigpond.net.au>
Message-ID: <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
References: <463166C2.6060106@bigpond.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Peter Williams wrote:
>
> The 2.6.21 kernel is hanging during the post boot phase where various daemons
> are being started (not always the same daemon unfortunately).
> 
> This problem was not present in 2.6.21-rc7 and there is no oops or other
> unusual output in the system log at the time the hang occurs.

Can you use "git bisect" to narrow it down a bit more? It's only 125 
commits, so bisecting even just three or four kernels will narrow it down 
to a handful.

		Linus
