Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXAXDBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXAXDBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965637AbXAXDBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:01:51 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:33532 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965636AbXAXDBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:01:50 -0500
Date: Tue, 23 Jan 2007 19:01:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: aubreylee@gmail.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
In-Reply-To: <20070124115310.48cda374.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0701231901130.6049@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
 <20070124115310.48cda374.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007, KAMEZAWA Hiroyuki wrote:

> if (sc->may_swap &&
>     zone_page_state(zone, NR_FILE_PAGES) &&
>     !(curreht->flags & PF_MEMALLOC))
> 	sc->may_swap = 0;

That is probably better than what we have so far.

