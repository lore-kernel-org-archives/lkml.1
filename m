Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZCSNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZCSNp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZCSNpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:45:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZCSNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:45:09 -0400
Date: Thu, 19 Mar 2009 14:45:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: David Miller <davem@davemloft.net>, ghaskins@novell.com, vernux@us.ibm.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090319134540.GW11935@one.firstfloor.org>
References: <49C16D7C.3080003@novell.com> <20090318.180355.228447835.davem@davemloft.net> <1237425191.8204.41.camel@quadrophenia.thebigcorporation.com> <20090318.181713.62394874.davem@davemloft.net> <1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we have to rule-out per-CPU queues, that aggregate into a master
> queue in a batch-wise manner? 

TSO/GSO/USO is that actually in a very specific way. It batches
packets into larger packets and then less per packet locks need to be taken.  
It was unclear if that was used in this workload or not.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
