Return-Path: <linux-kernel-owner+w=401wt.eu-S966002AbXDBWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966002AbXDBWu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966052AbXDBWuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:50:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36576 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966035AbXDBWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:49:58 -0400
Date: Mon, 2 Apr 2007 15:49:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Bligh <mbligh@google.com>
cc: Andi Kleen <ak@suse.de>, Dave Hansen <hansendc@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <461186A7.2020803@google.com>
Message-ID: <Pine.LNX.4.64.0704021546520.24316@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com>
 <1175550968.22373.122.camel@localhost.localdomain> <200704030031.24898.ak@suse.de>
 <Pine.LNX.4.64.0704021534100.25602@schroedinger.engr.sgi.com>
 <461186A7.2020803@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Martin Bligh wrote:

> > For 64GB you'd need 256M which would be a quarter of low mem. Probably takes
> > up too much of low mem.
> 
> Yup.

We could move whatever you currently use to handle that into i386 arch 
code. Or are there other platforms that do similar tricks with highmem?

We already have special hooks for node lookups in sparsemem. Move all of 
that off into some arch dir?

