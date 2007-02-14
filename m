Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXBNANk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXBNANk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbXBNANk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:13:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41437 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbXBNANj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:13:39 -0500
Date: Wed, 14 Feb 2007 09:12:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, akpm@osdl.org,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
Message-Id: <20070214091206.de21fd6f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702130924370.23752@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
	<200702130929.49349.andi@firstfloor.org>
	<20070213173830.285c3838.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702130924370.23752@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 09:25:00 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 13 Feb 2007, KAMEZAWA Hiroyuki wrote:
> 
> > NOD_DATA(nid) is always valid pointer if a node is online.
> > NODE_DATA(nid)->present_pages can be 0 even if a node is online, 
> > I call this as memory-less-node.
> 
> Yes but the pgdat will have no valid zone in it. That is new.
> 
we have populated_zone() macro for checking it.

(I noticed node-hotplug can create memory-less-zone until memory is
 onlined by the user.)


-Kame

