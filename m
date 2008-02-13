Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbYBMTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbYBMTC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBMTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:02:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47776 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754666AbYBMTCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:02:17 -0500
Date: Wed, 13 Feb 2008 11:02:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Raisch <RAISCH@de.ibm.com>
cc: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, avi@qumranet.com,
       a.p.zijlstra@chello.nl, daniel.blueman@quadrics.com,
       general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       Robin Holt <holt@sgi.com>, izike@qumranet.com,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>, steiner@sgi.com
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <OF02DFC038.7260E7CB-ONC12573EE.0047FE76-C12573EE.0042EBE0@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0802131101280.18472@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
 <20080208155641.2258ad2c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
 <adaprv70yyt.fsf@cisco.com> <Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>
 <adalk5v0yi6.fsf@cisco.com> <Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>
 <20080209012446.GB7051@v2.random> <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
 <20080209015659.GC7051@v2.random> <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
 <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
 <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger <adazlu5vlub.fsf@cisco.com>
 <OF02DFC038.7260E7CB-ONC12573EE.0047FE76-C12573EE.0042EBE0@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Christoph Raisch wrote:

> For ehca we currently can't modify a large MR when it has been allocated.
> EHCA Hardware expects the pages to be there (MRs must not have "holes").
> This is also true for the global MR covering all kernel space.
> Therefore we still need the memory to be "pinned" if ib_umem_get() is
> called.

It cannot be freed and then reallocated? What happens when a process 
exists?

