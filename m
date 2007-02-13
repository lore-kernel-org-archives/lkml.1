Return-Path: <linux-kernel-owner+w=401wt.eu-S1751288AbXBMR0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbXBMR0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXBMR0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:26:19 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:60708 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751288AbXBMR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:26:18 -0500
Date: Tue, 13 Feb 2007 09:25:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
In-Reply-To: <20070213173830.285c3838.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702130924370.23752@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
 <200702130929.49349.andi@firstfloor.org> <20070213173830.285c3838.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, KAMEZAWA Hiroyuki wrote:

> NOD_DATA(nid) is always valid pointer if a node is online.
> NODE_DATA(nid)->present_pages can be 0 even if a node is online, 
> I call this as memory-less-node.

Yes but the pgdat will have no valid zone in it. That is new.


