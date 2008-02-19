Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbYBSWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbYBSWR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbYBSWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:17:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36394 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbYBSWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:17:03 -0500
Subject: Re: [LTP] [PATCH 1/8] Scaling msgmni to the amount of lowmem
From: Matt Helsley <matthltc@us.ibm.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: subrata@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       ltp-list@lists.sourceforge.net, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, cmm@us.ibm.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <47BB0EDC.5000002@bull.net>
References: <20080211141646.948191000@bull.net>
	 <20080211141813.354484000@bull.net>
	 <20080215215916.8566d337.akpm@linux-foundation.org>
	 <47B94D8C.8040605@bull.net>  <47B9835A.3060507@bull.net>
	 <1203411055.4612.5.camel@subratamodak.linux.ibm.com>
	 <47BB0EDC.5000002@bull.net>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 19 Feb 2008 14:16:58 -0800
Message-Id: <1203459418.7408.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 18:16 +0100, Nadia Derbey wrote:

<snip>

> +#define MAX_MSGQUEUES  16      /* MSGMNI as defined in linux/msg.h */
> +

It's not quite the maximum anymore, is it? More like the minumum
maximum ;). A better name might better document what the test is
actually trying to do.

One question I have is whether the unpatched test is still valuable.
Based on my limited knowledge of the test I suspect it's still a correct
test of message queues. If so, perhaps renaming the old test (so it's
not confused with a performance regression) and adding your patched
version is best?

<snip>

Cheers,
	-Matt Helsley

