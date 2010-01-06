Return-Path: <linux-kernel-owner+w=401wt.eu-S933152Ab0AFXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab0AFXxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154Ab0AFXxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:53:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab0AFXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:53:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YvBbCGcNkzJDIJLpI0ljkClLIsmfLZhWXu93CCdA4R/wWkKSPCiJ6tHTJ0qpIH8L3
	cBR9jEFEmeEZW8jedGCeg==
Date: Wed, 6 Jan 2010 15:52:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       devicetree-discuss@lists.ozlabs.org, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, lee.schermerhorn@hp.com,
       benh@kernel.crashing.org, paulus@samba.org, dave@linux.vnet.ibm.com,
       miltonm@bga.com, nfont@austin.ibm.com, geoffrey.levand@am.sony.com,
       grant.likely@secretlab.ca, bfields@fieldses.org, neilb@suse.de,
       Trond.Myklebust@netapp.com, davem@davemloft.net, bhalevy@panasas.com,
       chuck.lever@oracle.com, Ricardo.Labiaga@netapp.com
Subject: Re: [PATCH] nodmask.h: remove macro any_online_node
In-Reply-To: <201001061624.59118.hartleys@visionengravers.com>
Message-ID: <alpine.DEB.2.00.1001061552220.19882@chino.kir.corp.google.com>
References: <201001061624.59118.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, H Hartley Sweeten wrote:

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
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

Acked-by: David Rientjes <rientjes@google.com>
