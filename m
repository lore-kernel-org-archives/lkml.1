Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbYBAB4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbYBAB4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYBAB4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:56:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45752 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097AbYBAB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:56:13 -0500
Date: Thu, 31 Jan 2008 19:56:12 -0600
From: Jack Steiner <steiner@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
Message-ID: <20080201015611.GA15893@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131045812.553249048@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2033,6 +2034,7 @@ void exit_mmap(struct mm_struct *mm)
>  	unsigned long end;
>  
>  	/* mm's last user has gone, and its about to be pulled down */
> +	mmu_notifier(invalidate_all, mm, 0);
>  	arch_exit_mmap(mm);
>  

The name of the "invalidate_all" callout is not very descriptive.
Why not use "exit_mmap". That matches the function name, the arch callout
and better describes what is happening.


--- jack


