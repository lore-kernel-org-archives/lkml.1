Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYH1QyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYH1QyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYH1QyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:54:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYH1QyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:54:08 -0400
Date: Thu, 28 Aug 2008 18:56:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Andi Kleen <andi@firstfloor.org>, Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080828165643.GS26610@one.firstfloor.org>
References: <20080827.201020.17601834.davem@davemloft.net> <21915755.1327801219904892242.JavaMail.root@ouachita> <20080828072218.GI26610@one.firstfloor.org> <200808281948.52608.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281948.52608.denys@visp.net.lb>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 07:48:52PM +0300, Denys Fedoryshchenko wrote:
> 1)Right now i have 400-500 Mbps passing router. If i will run 
> 5 "pings" ,simultaneous ,under _USER_ privileges(i know ping is suid), 
> instead of free 20% CPU time, i will have 1-2% free CPU time. Sure i know 
> ping is suid program, but it is has been "like this" since long time. By 
> security psychos it will be caled DoS.

The skb timestamp overhead does not add up, it's either on or off.
If multiple pings make the router slower it must be something else.

-Andi
-- 
ak@linux.intel.com
