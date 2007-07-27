Return-Path: <linux-kernel-owner+w=401wt.eu-S937469AbXG0Qj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937469AbXG0Qj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXG0QjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:39:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40712 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752516AbXG0QjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:39:18 -0400
Date: Fri, 27 Jul 2007 09:39:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Zoltan.Menyhart@bull.net
Subject: Re: [PATCH] flush cache fixes for ia64 [1/2] migration fix
In-Reply-To: <20070727133843.6cd3f57a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0707270934300.15619@schroedinger.engr.sgi.com>
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
 <20070727133843.6cd3f57a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will have no effect on x86_64, ia64 and i386. Maybe useful for 
virtually mapped platforms (parisc)?

asm-ia64/cacheflush.c

#define flush_icache_page(vma,page)             do { } while (0)

Acked-by: Christoph Lameter <clameter@sgi.com>

