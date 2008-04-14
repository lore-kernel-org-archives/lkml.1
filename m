Return-Path: <linux-kernel-owner+w=401wt.eu-S1763146AbYDNXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146AbYDNXKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYDNXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:09:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37477 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbYDNXJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:09:28 -0400
Date: Mon, 14 Apr 2008 16:09:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
In-Reply-To: <patchbomb.1207669443@duo.random>
Message-ID: <Pine.LNX.4.64.0804141559410.11036@schroedinger.engr.sgi.com>
References: <patchbomb.1207669443@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Andrea Arcangeli wrote:

> The difference with #v11 is a different implementation of mm_lock that
> guarantees handling signals in O(N). It's also more lowlatency friendly. 

Ok. So the rest of the issues remains unaddressed? I am glad that we 
finally settled on the locking. But now I will have to clean this up, 
address the remaining issues, sequence the patches right, provide docs, 
handle the merging issue etc etc? I have seen no detailed review of my 
patches that you include here.

We are going down the same road as we had to go with the OOM patches where 
David Rientjes and me had to deal with the issues you raised?
