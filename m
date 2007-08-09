Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbXHIUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbXHIUVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXHIUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:21:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbXHIUVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:21:08 -0400
Date: Thu, 9 Aug 2007 13:19:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
 zonelists v2
Message-Id: <20070809131943.64cb0921.akpm@linux-foundation.org>
In-Reply-To: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Aug 2007 17:15:04 +0100 (IST)
Mel Gorman <mel@csn.ul.ie> wrote:

> The following patches replace multiple zonelists per node with one zonelist
> that is filtered based on the GFP flags.

I think I'll duck this for now on im-trying-to-vaguely-stabilize-mm grounds.
Let's go with the horrible-hack for 2.6.23, then revert it and get this
new approach merged and stabilised over the next week or two?
