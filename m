Return-Path: <linux-kernel-owner+w=401wt.eu-S2992866AbXDDLr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992866AbXDDLr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992876AbXDDLr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:47:56 -0400
Received: from ns.suse.de ([195.135.220.2]:43940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992866AbXDDLrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:47:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable entries
Date: Wed, 4 Apr 2007 13:47:42 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20070402055652.610711908@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org>
In-Reply-To: <46136F25.7030907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041347.42822.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 11:25:57 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > What do the benchmarks say with CONFIG_PARAVIRT on native hardware
> > compared to !CONFIG_PARAVIRT. e.g. does lmbench suffer? 
> 
> Barely.  There's a slight hit for not using patching, and patching is
> almost identical to native performance.  The most noticeable difference
> is in the null syscall microbenchmark, but once you get to complex
> things the difference is in the noise.

Why is there a difference for null syscall? I had assumed we patched all the 
fast path cases relevant there. Do you have an idea where it comes from?

-Andi
