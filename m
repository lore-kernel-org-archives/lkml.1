Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbYBNTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbYBNTfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYBNTfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:35:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56907 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517AbYBNTfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:35:39 -0500
Date: Thu, 14 Feb 2008 11:35:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kanoj Sarcar <kanojsarcar@yahoo.com>
cc: Christian Bell <christian.bell@qlogic.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <866658.37093.qm@web32510.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0802141133430.477@schroedinger.engr.sgi.com>
References: <866658.37093.qm@web32510.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Kanoj Sarcar wrote:

> Oh ok, yes, I did see the discussion on this; sorry I
> missed it. I do see what notifiers bring to the table
> now (without endorsing it :-)).
> 
> An orthogonal question is this: is IB/rdma the only
> "culprit" that elevates page refcounts? Are there no
> other subsystems which do a similar thing?

Yes there are actually two projects by SGI that also ran into the same 
issue that motivated the work on this. One is XPmem which allows 
sharing of process memory between different Linux instances and then 
there is the GRU which is a kind of DMA engine. Then there is KVM and 
probably multiple other drivers.
