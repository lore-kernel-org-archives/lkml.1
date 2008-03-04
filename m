Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYCDOoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYCDOoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYCDOoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:44:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45087 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754051AbYCDOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:44:23 -0500
Date: Tue, 4 Mar 2008 08:44:06 -0600
From: Jack Steiner <steiner@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@qumranet.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8
Message-ID: <20080304144406.GA25467@sgi.com>
References: <20080302155457.GK8091@v2.random> <20080303032934.GA3301@wotan.suse.de> <20080303125152.GS8091@v2.random> <20080303131017.GC13138@wotan.suse.de> <20080303151859.GA19374@sgi.com> <20080303165910.GA23998@wotan.suse.de> <20080303180605.GA3552@sgi.com> <20080303184517.GA4951@wotan.suse.de> <20080303191540.GB11156@sgi.com> <1204626932.6241.41.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204626932.6241.41.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 11:35:32AM +0100, Peter Zijlstra wrote:
> 
> On Mon, 2008-03-03 at 13:15 -0600, Jack Steiner wrote:
> 
> > I haven't thought about locking requirements for the radix tree. Most accesses
> > would be read-only & updates infrequent. Any chance of an RCU-based radix
> > implementation?  Otherwise, don't we add the potential for hot locks/cachelines
> > for threaded applications ???
> 
> The current radix tree implementation in the kernel is RCU capable. We
> just don't have many RCU users yet.

Ahhh. You are right. I thought I looked but obviously missed it.
