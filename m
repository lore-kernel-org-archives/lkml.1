Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbXK2Ptt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbXK2Ptt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXK2Ptl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:49:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbXK2Ptk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:49:40 -0500
Date: Thu, 29 Nov 2007 10:47:26 -0500
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@sw.ru>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Christoph Lameter <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: What can we do to get ready for memory controller merge in
 2.6.25
Message-ID: <20071129104726.5698321f@cuia.boston.redhat.com>
In-Reply-To: <474ED005.7060300@linux.vnet.ibm.com>
References: <474ED005.7060300@linux.vnet.ibm.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 20:13:17 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> They say better strike when the iron is hot.
> 
> Since we have so many people discussing the memory controller, I would
> like to access the readiness of the memory controller for mainline
> merge.

> At the VM-Summit we decided to try the current double LRU approach for
> memory control. At this juncture in the space-time continuum, I seek
> your support, feedback, comments and help to move the memory controller

The memory controller code currently in -mm seems fine to me,
especially with the changes that got committed over the last
days making reclaim more efficient.

I don't think there are any bugs left that can be found by
code inspection - only the kind of testing that the mainline
kernel gets might shake out more bugs.

I would like to see the memory controller code go into the
mainline kernel ASAP.

-- 
All Rights Reversed
