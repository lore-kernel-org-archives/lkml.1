Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXH1AbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXH1AbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 20:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXH1AbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 20:31:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3079 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbXH1AbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 20:31:16 -0400
Subject: Re: [PATCH] trivial - convert "for(foo=0;foo<NR_CPUS;foo++)" to
	"for_each_possible_cpu(foo)"
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Mike Travis <travis@sgi.com>
In-Reply-To: <20070827171227.285b7383.akpm@linux-foundation.org>
References: <1188258887.18004.173.camel@localhost>
	 <20070827171227.285b7383.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 17:31:05 -0700
Message-Id: <1188261065.18004.178.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 17:12 -0700, Andrew Morton wrote:
> Right now, pretty much every instance of NR_CPUS in the tree is a flag
> which says "old, krufty, fixme".

I thought of that when I changed them.

Perhaps the new for_each_possible_cpu code can
now be more easily inspected/transformed by the
appropriate parties to for_each_(online|present)_cpu.

cheers, Joe

