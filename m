Return-Path: <linux-kernel-owner+w=401wt.eu-S2993045AbXCIHWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993045AbXCIHWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993047AbXCIHWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:22:10 -0500
Received: from poczta.o2.pl ([193.17.41.142]:39668 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993040AbXCIHWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:22:08 -0500
Date: Fri, 9 Mar 2007 08:26:10 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Miller <davem@davemloft.net>
Cc: peter.p.waskiewicz.jr@intel.com, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       auke@foo-projects.org, john.ronciak@intel.com
Subject: Re: [PATCH 1/2] NET: Multiple queue network device support
Message-ID: <20070309072610.GA1662@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307.144248.48528321.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-03-2007 23:42, David Miller wrote:
> I didn't say to use skb->priority, I said to shrink skb->priority down
> to a u16 and then make another u16 which will store your queue mapping
> value.

Peter is right: this is fully used by schedulers (prio,
CBQ, HTB, HFSC...) and would break users' scripts, so I
wouldn't recommend, too.

Regards,
Jarek P.
