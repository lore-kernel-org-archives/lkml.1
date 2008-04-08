Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYDHVrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYDHVrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYDHVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:47:29 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39721
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYDHVr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:47:28 -0400
Message-ID: <47FBE7C9.9000701@qumranet.com>
Date: Wed, 09 Apr 2008 00:46:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 9] mmu notifier #v12
References: <patchbomb.1207669443@duo.random>
In-Reply-To: <patchbomb.1207669443@duo.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> Note that mmu_notifier_unregister may also fail with -EINTR if there are
> signal pending or the system runs out of vmalloc space or physical memory,
> only exit_mmap guarantees that any kernel module can be unloaded in presence
> of an oom condition.
>
>   

That's unusual.  What happens to the notifier?  Suppose I destroy a vm 
without exiting the process, what happens if it fires?

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

