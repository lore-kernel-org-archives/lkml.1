Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXJCBGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXJCBGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXJCBF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:05:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44155 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753259AbXJCBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:05:55 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 18:04:55 -0700
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA v2
Message-ID: <20071003010455.GD26752@sgi.com>
References: <20070928010926.GM30013@sgi.com> <20070928.154339.02281405.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928.154339.02281405.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 03:43:39PM -0700, David Miller wrote:
> ....
> My only beef with this patch set is that it seems
> a bit much to create a totally new function name every
> time we want to set some kind of new attribute on some
> DMA object.  Why not add a "dma_set_flags()" or similar
> that can be used later on to set other kinds of aspects
> we'd like to change?
> 
> You can make the arguments "u32 flags" and "int dir".
> Actually you should probably use the dma direction
> enumaration instead of 'int'.

OK, this will be in the next version along with the 
coding style changes you mentioned.

-- 
Arthur

