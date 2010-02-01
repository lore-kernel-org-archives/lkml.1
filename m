Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0BACKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 21:10:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:55909 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0BACKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 21:10:12 -0500
Subject: Re: [PATCH] nodmask.h: remove macro any_online_node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       devicetree-discuss@lists.ozlabs.org, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, lee.schermerhorn@hp.com,
       paulus@samba.org, dave@linux.vnet.ibm.com, miltonm@bga.com,
       nfont@austin.ibm.com, geoffrey.levand@am.sony.com,
       grant.likely@secretlab.ca, bfields@fieldses.org, neilb@suse.de,
       Trond.Myklebust@netapp.com, davem@davemloft.net, bhalevy@panasas.com,
       chuck.lever@oracle.com, Ricardo.Labiaga@netapp.com
In-Reply-To: <201001061624.59118.hartleys@visionengravers.com>
References: <201001061624.59118.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 13:05:58 +1100
Message-ID: <1264989958.8287.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 16:24 -0700, H Hartley Sweeten wrote:
> nodmask.h: remove macro any_online_node
> 
> The macro any_online_node is prone to producing sparse warnings
> due to the local symbol 'node'. Since all the in-tree users are really
> requesting the first online node (the mask argument is either
> NODE_MASK_ALL or node_online_map) just use the first_online_node
> macro and remove the any_online_node macro since there are no users.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Milton Miller <miltonm@bga.com>
> Cc: Nathan Fontenot <nfont@austin.ibm.com>
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: J. Bruce Fields <bfields@fieldses.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Benny Halevy <bhalevy@panasas.com>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>

Cheers,
Ben.


