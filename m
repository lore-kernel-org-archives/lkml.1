Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbYD2RIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbYD2RIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYD2RIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:08:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37710 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbYD2RIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:08:30 -0400
Date: Tue, 29 Apr 2008 10:08:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080429084854.GA14913@elte.hu>
Message-ID: <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080429084854.GA14913@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Ingo Molnar wrote:

> i pointed out how it should be done _much cleaner_ (and much smaller - 
> only a single patch needed) via stack-trace, without changing a dozen 
> architectures, and even gave a patch to make it all easier for you:
> 
>     http://lkml.org/lkml/2008/3/19/568
>     http://lkml.org/lkml/2008/3/21/88
> 
> in fact, a stacktrace printout is much more informative as well to 
> users, than a punny __builtin_return_address(0)!

Sorry lost track of this issue. Adding stracktrace support is not a 
trivial thing and will change the basic handling of vmallocinfo.

Not sure if stacktrace support can be enabled without a penalty on various 
platforms. Doesnt this require stackframes to be formatted in a certain 
way?

