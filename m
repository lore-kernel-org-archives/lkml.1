Return-Path: <linux-kernel-owner+w=401wt.eu-S1761535AbYDVNBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535AbYDVNBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYDVNBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:01:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46683 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758775AbYDVNBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:01:23 -0400
Date: Tue, 22 Apr 2008 08:01:20 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
Message-ID: <20080422130120.GR22493@sgi.com>
References: <patchbomb.1207669443@duo.random> <20080409131709.GR11364@sgi.com> <20080409144401.GT10133@duo.random> <20080409185500.GT11364@sgi.com> <20080422072026.GM12709@duo.random> <20080422120056.GR12709@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422120056.GR12709@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:00:56PM +0200, Andrea Arcangeli wrote:
> On Tue, Apr 22, 2008 at 09:20:26AM +0200, Andrea Arcangeli wrote:
> >     invalidate_range_start {
> > 	spin_lock(&kvm->mmu_lock);
> > 
> > 	kvm->invalidate_range_count++;
> > 	rmap-invalidate of sptes in range
> > 
> 
> 	write_seqlock; write_sequnlock;

I don't think you need it here since invalidate_range_count is already
elevated which will accomplish the same effect.

Thanks,
Robin
