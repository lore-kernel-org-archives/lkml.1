Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXBGLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXBGLcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXBGLcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:32:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161218AbXBGLcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:32:47 -0500
From: Andi Kleen <ak@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with memory-less-node
Date: Wed, 7 Feb 2007 12:32:36 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, clameter@engr.sgi.com,
       akpm@osdl.org
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com> <200702071141.25990.ak@suse.de> <20070207194909.658aa454.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070207194909.658aa454.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071232.36689.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> How for_each_online_node(nid) works ? it can handle alias-nid ?
> 
> ==
> 	for_each_online_node(nid) {
> 		pgdat = NODE_DATA(nid);
> ==
> This code never accesses pgdat_for_A twice ?

It would. If there's a problem it could be changed to walk the pgdat lists instead,
but at least when x86-64 still did it there wasn't.

-Andi
