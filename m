Return-Path: <linux-kernel-owner+w=401wt.eu-S965652AbXAXEcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965652AbXAXEcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030183AbXAXEcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:32:23 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:35564 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965652AbXAXEcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:32:22 -0500
Date: Tue, 23 Jan 2007 20:30:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: aubreylee@gmail.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
In-Reply-To: <20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0701232028520.6820@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
 <20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, KAMEZAWA Hiroyuki wrote:

> I don't prefer to cause zone fallback by this.
> This may use ZONE_DMA before exhausing ZONE_NORMAL (ia64),

Hmmm... We could use node_page_state instead of zone_page_state.

> Very rapid page allocation can eats some amount of lower zone.

One queston: For what purpose would you be using the page cache size 
limitation?

