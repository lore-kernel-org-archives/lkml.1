Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbXGFRco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbXGFRco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXGFRce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:32:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52555 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764000AbXGFRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:32:33 -0400
Date: Fri, 6 Jul 2007 10:32:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Mike.stroya@hp.com,
       GOTO <y-goto@jp.fujitsu.com>, dmosberger@gmail.com, hugh@veritas.com
Subject: Re: [BUGFIX][PATCH] DO flush icache before set_pte() on ia64.
In-Reply-To: <20070705125427.9a3b8e8b.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0707061032040.30575@schroedinger.engr.sgi.com>
References: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
 <468B3EAA.9070905@yahoo.com.au> <20070704163826.d0b7465b.kamezawa.hiroyu@jp.fujitsu.com>
 <468C51A7.3070505@yahoo.com.au> <20070705114726.2449f270.kamezawa.hiroyu@jp.fujitsu.com>
 <468C634D.9050306@yahoo.com.au> <20070705125427.9a3b8e8b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am a bit worried about the performance impact of all this flushing? What 
is the worst case scenario here?

