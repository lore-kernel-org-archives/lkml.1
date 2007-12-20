Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbXLTTIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbXLTTIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXLTTIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:08:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44152 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbXLTTIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:08:09 -0500
From: akepner@sgi.com
Date: Thu, 20 Dec 2007 11:06:42 -0800
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
Message-ID: <20071220190642.GM412@sgi.com>
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com> <476834AC.9050401@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476834AC.9050401@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 09:59:24PM +0100, Stefan Richter wrote:
> 
> From its purpose it sounds like you need this only for few special
> memory regions which would typically be mapped by dma_map_single() 

We need the _sg versions too, as Roland already mentioned.

> .... and
> furthermore that drivers who need this behavior will be changed to
> explicitly demand it.  If so, a nonintrusive API extension could simply
> be to add an
> 
> dma_addr_t dma_map_single_write_last(struct device *dev, void *ptr,
> size_t size, enum dma_data_direction direction);
> ...

This is the easiest thing to do, and therefore it'd be my 
preference. But I'm concerned that the keepers of the dma 
interface will object to this. So far they've been silent 
in this thread - maybe they need to see a patch before 
they'll get engaged....

-- 
Arthur

