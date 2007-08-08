Return-Path: <linux-kernel-owner+w=401wt.eu-S936790AbXHHUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936790AbXHHUjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXHHUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:39:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43608 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754175AbXHHUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:39:03 -0400
Date: Wed, 8 Aug 2007 13:39:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Lucio Correia <ljhc@br.ibm.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <200708082234.40104.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0708081336020.14586@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain>
 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
 <200708082234.40104.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Arnd Bergmann wrote:

> In the future, we also may have configurations where we need to run with
> memoryless nodes on a production environment, so it should really just
> work.

Memoryless node support is work in progress currently in mm. You may 
encounter strange NUMA issues if you try to run a memoryless node right 
now.

> What makes you assume that there is one page in the node? AFAICS, it
> is a CPU-only node already without any pages.

The boot output shows:

Zone PFN ranges:
  DMA             0 ->    12288
  Normal      12288 ->    12288
early_node_map[2] active PFN ranges
    0:        0 ->     2560
    1:    12287 ->    12288

Remove the page and you should be fine.

