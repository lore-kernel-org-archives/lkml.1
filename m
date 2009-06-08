Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZFHWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZFHWLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZFHWLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:11:03 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:64014 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZFHWLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:11:01 -0400
X-IronPort-AV: E=Sophos;i="4.41,326,1241395200"; 
   d="scan'208";a="168099912"
Date: Mon, 8 Jun 2009 15:11:02 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 1/7] initdev:kernel:Asynchronously-discovered device
	synchronization, v6
Message-ID: <20090608221102.GA22222@cuplxvomd02.corp.sa.net>
References: <20090606023403.GA5645@cuplxvomd02.corp.sa.net> <4A2A2C26.1070106@s5r6.in-berlin.de> <4A2A320F.5020008@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2A320F.5020008@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 05:08:31AM -0400, Stefan Richter wrote:
> I wrote:
> > What happens if the calls or the call arguments aren't balanced, e.g. 
> > due to a mistake in an error path?  The kernel will hang?
> 
> Yes, unless the waiting subsystems implement timeouts.

This is absolutely correct. It would, of course, be possible to add a
timeout, but it would really be papering over a bug. If this every happened,
the proper thing would be to fix the problem.

> Stefan Richter
