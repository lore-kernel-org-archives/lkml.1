Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXDIUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXDIUY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXDIUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:24:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58971 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXDIUY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:24:27 -0400
Date: Mon, 9 Apr 2007 13:23:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       David Rientjes <rientjes@google.com>
Cc: christoph@lameter.com, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86_64: set node_possible_map at runtime.
Message-Id: <20070409132341.18fe0565.akpm@linux-foundation.org>
In-Reply-To: <20070409180145.GA3948@linux-os.sc.intel.com>
References: <20070320213218.GA13952@one.firstfloor.org>
	<Pine.LNX.4.64.0703201716440.17799@graphe.net>
	<20070321024452.GA17532@one.firstfloor.org>
	<Pine.LNX.4.64.0703202006230.20568@graphe.net>
	<20070322212831.GA25665@linux-os.sc.intel.com>
	<4602FF57.7030001@cosmosbay.com>
	<20070322224045.GA3200@linux-os.sc.intel.com>
	<20070323141210.GA20548@one.firstfloor.org>
	<20070402225512.GA31026@linux-os.sc.intel.com>
	<Pine.LNX.4.64.0704021722300.20493@graphe.net>
	<20070409180145.GA3948@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 11:01:45 -0700
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:

> Set the node_possible_map at runtime on x86_64. On a non NUMA system,
> num_possible_nodes() will now say '1'.
> 

I had to rework this a bit in the numa-emulation case due to changes in
Andi's tree.  The change to numa_emulation() got moved into
setup_node_range().

We have 166 x86 patches pending at present - the chances of a patch against
mainline applying and working against the development tree are reduced.


