Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYCKGfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYCKGfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYCKGfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:35:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYCKGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:35:22 -0400
Date: Tue, 11 Mar 2008 02:35:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: maxk@qualcomm.com
Cc: mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
Message-ID: <20080311063514.GA29824@infradead.org>
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com> <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205215046-27085-2-git-send-email-maxk@qualcomm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 10:57:25PM -0700, maxk@qualcomm.com wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Hi Paul,
> 
> How about something like this; along with the in-kernel version
> of /cgroup/boot this could also provide the desired semantics.
> 
> Another benefit of this approach would be that it no longer requires
> PF_THREAD_BIND, as we'd only stick unbounded kthreads into that cgroup.

Looks like my comments to the last posting of this are still not
addressed.

