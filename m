Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbXDFGbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbXDFGbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 02:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbXDFGbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 02:31:06 -0400
Received: from graphe.net ([209.204.138.32]:44362 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbXDFGa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 02:30:58 -0400
Date: Thu, 5 Apr 2007 23:30:56 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Patrick Ringl <patrick_@freenet.de>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 2.6.21-rc6] mm/page_alloc.c: removal of an unused definition
 of 'setup_n_node_ids'
In-Reply-To: <4615DC61.6080606@freenet.de>
Message-ID: <Pine.LNX.4.64.0704052328010.12458@graphe.net>
References: <4615DC61.6080606@freenet.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Patrick Ringl wrote:

> Remove an empty and thus unused definition of 'setup_nr_node_ids' (in case of
> MAX_NUMNODES < 1) in order to resolve a compiler warning.

You mean MAX_NUMNODES == 1?

Also that empty and unused definition is used by

free_area_init_nodes()
