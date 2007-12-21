Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbXLUSCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbXLUSCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 13:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXLUSBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 13:01:52 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57843 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751402AbXLUSBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 13:01:52 -0500
From: akepner@sgi.com
Date: Fri, 21 Dec 2007 10:00:22 -0800
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
Message-ID: <20071221180022.GW412@sgi.com>
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com> <1198184185.6779.16.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198184185.6779.16.camel@pasglop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 07:56:25AM +1100, Benjamin Herrenschmidt wrote:
> ...
> Can't you just have a primitive to sync things up that you call
> explicitely from your driver after fetching a new status entry ?
> 

Well, the only mechanisms I know to get things synced are the ones 
I mentioned before: 1) generate an interrupt, 2) write to memory 
which has the "barrier" attribute. Obviously 1 is out - giving  
the memory used for status indications the barrier attribute is 
the most primitive means I'm aware of.

-- 
Arthur

