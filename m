Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYJCMuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYJCMuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYJCMuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:50:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYJCMuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:50:02 -0400
Message-ID: <48E614A0.60209@linux-foundation.org>
Date: Fri, 03 Oct 2008 07:48:32 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rusty@rustcorp.com.au,
       jeremy@goop.org, ebiederm@xmission.com, travis@sgi.com,
       herbert@gondor.apana.org.au, xemul@openvz.org, penberg@cs.helsinki.fi
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080929193500.470295078@quilx.com>	<20080929193516.278278446@quilx.com> <20081003003342.4d592c1f.akpm@linux-foundation.org>
In-Reply-To: <20081003003342.4d592c1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> And bitmap_etc().  We have a pretty complete suite there.

ok will use bitops here.

 > Apart from that the interface, intent and implementation seem reasonable.
> 
> But I'd have though that it would be possible to only allocate the
> storage for online CPUs.  That would be a pretty significant win for
> some system configurations?

We  have tried that but currently the kernel (core and in particular arch
code) keeps state for all possible cpus in percpu segments. Would require more
extensive cleanup of numerous arches to do.


