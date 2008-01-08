Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYAHCd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYAHCd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYAHCdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:33:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46730 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539AbYAHCdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:33:50 -0500
From: akepner@sgi.com
Date: Mon, 7 Jan 2008 18:32:22 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
Message-ID: <20080108023222.GP23661@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patchset allows additional "attributes" to be 
passed to dma_map_*/dma_unmap_* implementations. (The reason 
why this is useful/necessary has been mentioned several times, 
most recently here:
http://marc.info/?l=linux-kernel&m=119258541412724&w=2.)

This is incomplete in that only ia64 and x86_64 are supported - 
the purpose is mainly to give us something specific to discuss. 

The approach here is to change the dma_map_* interface so 
that the last argument is an u32 which encodes the direction 
of the dma and, optionally, other attributes. Changing the 
interface is a bit intrusive, but callers of dma_map_* don't 
need to be modified.

There are 3 patches:

[1/3] dma: create linux/dma-direction.h 
[2/3] dma: ia64/sn2 allow "attributes" to be used by dma_map_*
[2/3] dma: x86_64 allow "attributes" to be used by dma_map_*

-- 
Arthur

