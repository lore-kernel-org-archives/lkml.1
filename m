Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZAWNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZAWNfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZAWNfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:35:25 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53996 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbZAWNfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:35:24 -0500
Date: Fri, 23 Jan 2009 13:34:49 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Nick Piggin <npiggin@suse.de>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090123090042.GB19986@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0901231326520.9011@blonde.anvils>
References: <20090121143008.GV24891@wotan.suse.de> <1232613933.11429.127.camel@ymzhang>
 <20090123090042.GB19986@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nick Piggin wrote:
> 
> ... Would you be able to test with this updated patch
> (which also includes Hugh's fix ...

In fact not: claim_remote_free_list() still has the offending unlocked
+	VM_BUG_ON(!l->remote_free.list.head != !l->remote_free.list.tail);

Hugh
