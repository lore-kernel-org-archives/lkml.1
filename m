Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYDPTT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYDPTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYDPTTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:19:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51612 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751687AbYDPTTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:19:45 -0400
Date: Wed, 16 Apr 2008 12:19:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>, lizf@cn.fujitsu.com,
       menage@google.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use vmalloc for mem_cgroup allocation.
In-Reply-To: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0804161219190.14718@schroedinger.engr.sgi.com>
References: <20080415105434.3044afb6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, KAMEZAWA Hiroyuki wrote:

> On ia64, kmalloc() in mem_cgroup_create requires order-4 pages. But this is not
> necessary to be phisically contiguous. And we'll see page allocation failure.
> (Note: x86-32, which has small vmalloc area, has small mem_cgroup struct.)
> For here, vmalloc is better.

I need to get my virtualizable compound stuff in order. That would address 
these issues.
