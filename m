Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYLMNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYLMNso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbYLMNsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:48:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33335 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680AbYLMNse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:48:34 -0500
X-Sasl-enc: 9jJVyZ7y5+zsiwTqgABuR/NNWzV31lRD/4my9ZmO4lk2 1229176112
Date: Sat, 13 Dec 2008 11:48:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Vince Weaver <vince@deater.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081213134829.GB11428@khazad-dum.debian.net>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins> <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com> <1229167048.13566.119.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229167048.13566.119.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, Peter Zijlstra wrote:
> You have just irrevocably proven to me this needs to go into the kernel,
> as the design of perfmon is little more than a GPL circumvention device
> - independent of whether you are aware of that or not.

As long as it uses some sort of "module plugin" approach, perhaps coupled to
the firmware loader system to avoid wasting a ton of space with tables for
processors other than the one you need...  you could just move all of the
hardware-related parts of perfmon lib into the kernel.

That would close the doors to non-gpl badness.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
