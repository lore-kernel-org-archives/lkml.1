Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXIEKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXIEKcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXIEKcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:32:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33945 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755527AbXIEKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:32:34 -0400
Date: Wed, 5 Sep 2007 03:32:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Marco Berizzi <pupilla@hotmail.com>
cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       mel@skynet.ie
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0709050331340.8127@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
 <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
 <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl>
 <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
 <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Marco Berizzi wrote:

> > tcp_collapse? This is due to a network configuration that required an
> > order 2 kmalloc block. Jumbo frames?
> 
> I don't use jumbo frames. Hardware is
> very old (celeron with 3com 3c905).

Something must be doing allocations that requires between 8k and 16k that
SLUB cannot satisfy from order 0 or order 1 allocations.

