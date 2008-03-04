Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYCDKgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYCDKgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYCDKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:35:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55120 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbYCDKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:35:57 -0500
Subject: Re: [PATCH] mmu notifiers #v8
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@qumranet.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080303191540.GB11156@sgi.com>
References: <20080221161028.GA14220@sgi.com>
	 <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random>
	 <20080303032934.GA3301@wotan.suse.de> <20080303125152.GS8091@v2.random>
	 <20080303131017.GC13138@wotan.suse.de> <20080303151859.GA19374@sgi.com>
	 <20080303165910.GA23998@wotan.suse.de> <20080303180605.GA3552@sgi.com>
	 <20080303184517.GA4951@wotan.suse.de>  <20080303191540.GB11156@sgi.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 11:35:32 +0100
Message-Id: <1204626932.6241.41.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 13:15 -0600, Jack Steiner wrote:

> I haven't thought about locking requirements for the radix tree. Most accesses
> would be read-only & updates infrequent. Any chance of an RCU-based radix
> implementation?  Otherwise, don't we add the potential for hot locks/cachelines
> for threaded applications ???

The current radix tree implementation in the kernel is RCU capable. We
just don't have many RCU users yet.

