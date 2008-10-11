Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYJKNzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYJKNzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYJKNyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:54:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57466 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYJKNyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:54:52 -0400
Date: Sat, 11 Oct 2008 16:01:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
Message-ID: <20081011140119.GC12131@one.firstfloor.org>
References: <20081009171453.GA15321@redhat.com> <200810112242.28229.nickpiggin@yahoo.com.au> <20081011131115.GB12131@one.firstfloor.org> <200810120048.31141.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810120048.31141.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No immediate ideas. Jens probably is a good person to cc. With direct IO
> workloads, hd_struct should mostly only be touched in partition remapping
> and IO accounting.

I found it doubtful if grouping the rw and ro members together was a good
idea.

> At this point, you would want to cacheline align hd_struct. So if you

The problem is probably not false sharing, but simply cache misses because it's
so big. I think.

-Andi
-- 
ak@linux.intel.com
