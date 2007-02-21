Return-Path: <linux-kernel-owner+w=401wt.eu-S965370AbXBUJ0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370AbXBUJ0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXBUJ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:26:11 -0500
Received: from poczta.o2.pl ([193.17.41.142]:44430 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965356AbXBUJ0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:26:09 -0500
Date: Wed, 21 Feb 2007 10:29:36 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge/br_if.c: fix possible use-after-free in port_carrier_check()
Message-ID: <20070221092936.GA2311@ff.dom.local>
References: <20070220221941.GA707@tv-sign.ru> <20070220162434.72d3ad7b@freekitty> <20070221082345.GB1662@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221082345.GB1662@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 09:23:45AM +0100, Jarek Poplawski wrote:
...
> I have known issues with RCU, but dare to disagree here.
> It's done during call_rcu, so anything RCU friendly shouldn't
> see this at the moment at all. It could be needed for those
> with refcounting - than it should be checked, if there is
> anything more than port_carrier_check.

Sorry for this than-ing!
(It's my next favorite issue after RCU.)

Jarek P.
