Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbXLKVwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbXLKVwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXLKVw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:52:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbXLKVw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:52:27 -0500
Date: Tue, 11 Dec 2007 13:51:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Lee.Schermerhorn@hp.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       clameter@sgi.com
Subject: Re: [PATCH 0/6] Use two zonelists per node instead of multiple
 zonelists v11r2
Message-Id: <20071211135122.7a4a8dec.akpm@linux-foundation.org>
In-Reply-To: <20071211202157.1961.27940.sendpatchset@skynet.skynet.ie>
References: <20071211202157.1961.27940.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 20:21:57 +0000 (GMT)
Mel Gorman <mel@csn.ul.ie> wrote:

> This is a rebase of the two-zonelist patchset to 2.6.24-rc4-mm1 and some
> warnings cleared up.

Sorry, but I don't think I'll be looking at anything which looks like it
isn't a bugfix for a while.

I'm swamped in regressions (and everyone else should be too) but also we
need to look at why there were so many regressions - people jamming way too
much inadequately tested stuff into the 2.6.24 merge window.  The only way
we can fix that is to merge less stuff and to more carefully review and
test the things which we _do_ plan on merging.

Part of that process is for me to get more -mm kernels out and to test them
more and to encourage more people to test them and to report and fix
problems.  But I've hardly looked at the -mm queue in a week because of
2.6.24 regressions.

argh.
