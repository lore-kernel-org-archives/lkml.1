Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYBUIk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYBUIk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYBUIkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:40:16 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48289 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYBUIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:40:14 -0500
Message-ID: <47BD38AB.80408@bull.net>
Date: Thu, 21 Feb 2008 09:39:07 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
Cc: subrata@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       ltp-list@lists.sourceforge.net, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, cmm@us.ibm.com,
       y-goto@jp.fujitsu.com
Subject: Re: [LTP] [PATCH 1/8] Scaling msgmni to the amount of lowmem
References: <20080211141646.948191000@bull.net>	 <20080211141813.354484000@bull.net>	 <20080215215916.8566d337.akpm@linux-foundation.org>	 <47B94D8C.8040605@bull.net>  <47B9835A.3060507@bull.net>	 <1203411055.4612.5.camel@subratamodak.linux.ibm.com>	 <47BB0EDC.5000002@bull.net> <1203459418.7408.39.camel@localhost.localdomain>
In-Reply-To: <1203459418.7408.39.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Tue, 2008-02-19 at 18:16 +0100, Nadia Derbey wrote:
> 
> <snip>
> 
>>+#define MAX_MSGQUEUES  16      /* MSGMNI as defined in linux/msg.h */
>>+
> 
> 
> It's not quite the maximum anymore, is it? More like the minumum
> maximum ;). A better name might better document what the test is
> actually trying to do.
> 
> One question I have is whether the unpatched test is still valuable.
> Based on my limited knowledge of the test I suspect it's still a correct
> test of message queues. If so, perhaps renaming the old test (so it's
> not confused with a performance regression) and adding your patched
> version is best?
> 

Yes, you're completely right.

I'll resend a patch today.

Regards,
Nadia
