Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYBAXTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYBAXTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYBAXTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:19:35 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757830AbYBAXTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:19:34 -0500
Date: Fri, 1 Feb 2008 15:19:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/4] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080201220952.GA3875@sgi.com>
Message-ID: <Pine.LNX.4.64.0802011517430.20608@schroedinger.engr.sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.344041545@sgi.com>
 <20080201220952.GA3875@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Robin Holt wrote:

> We are getting this callout when we transition the pte from a read-only
> to read-write.  Jack and I can not see a reason we would need that
> callout.  It is causing problems for xpmem in that a write fault goes
> to get_user_pages which gets back to do_wp_page that does the callout.

Right. You placed it there in the first place. So we can drop the code 
from do_wp_page?

