Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYBACj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYBACj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYBACjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:39:21 -0500
Received: from relay1.sgi.com ([192.48.171.29]:35410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbYBACjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:39:20 -0500
Date: Thu, 31 Jan 2008 18:39:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
In-Reply-To: <20080201023113.GB26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801311838070.26594@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com>
 <20080201023113.GB26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Robin Holt wrote:

> Jack has repeatedly pointed out needing an unregister outside the
> mmap_sem.  I still don't see the benefit to not having the lock in the mm.

I never understood why this would be needed. ->release removes the 
mmu_notifier right now.

