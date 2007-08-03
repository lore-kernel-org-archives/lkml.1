Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbXHCQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbXHCQh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXHCQhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:37:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbXHCQhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:37:50 -0400
Date: Fri, 3 Aug 2007 09:37:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Marco Berizzi <pupilla@hotmail.com>
cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>]
 xfs_bmap_search_multi_extents+0x6f/0xe0)
In-Reply-To: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you try this with the SLUB allocator and then boot with 
"slub_debug"?


