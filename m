Return-Path: <linux-kernel-owner+w=401wt.eu-S1030252AbXBGM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252AbXBGM17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030618AbXBGM17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:27:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45337 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030252AbXBGM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:27:58 -0500
Date: Wed, 7 Feb 2007 21:27:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207212727.6aacb0b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200702071232.36689.ak@suse.de>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<200702071141.25990.ak@suse.de>
	<20070207194909.658aa454.kamezawa.hiroyu@jp.fujitsu.com>
	<200702071232.36689.ak@suse.de>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 12:32:36 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> > How for_each_online_node(nid) works ? it can handle alias-nid ?
> > 
> > ==
> > 	for_each_online_node(nid) {
> > 		pgdat = NODE_DATA(nid);
> > ==
> > This code never accesses pgdat_for_A twice ?
> 
> It would. If there's a problem it could be changed to walk the pgdat lists instead,
> but at least when x86-64 still did it there wasn't.
> 

Thank you for discussion. 

I'll try another hot-fix just for this NULL pointer access problem,
which is not invasive and not costly.

Thanks,
-Kame


