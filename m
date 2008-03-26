Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYCZWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYCZWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYCZWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:25:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49923 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752758AbYCZWZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:25:50 -0400
Date: Wed, 26 Mar 2008 17:25:48 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [Patch 0/5] prepare XPC and XPNET to support SGI UV -v3
Message-ID: <20080326222548.GF31138@sgi.com>
References: <20080326215807.GF31340@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326215807.GF31340@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 04:58:07PM -0500, Dean Nelson wrote:
> This set of five patches moves XPC and XPNET to drivers/misc/xp in preparation
> for enabling X86_64 support.
> 
> I discovered that the previous versions of this patch were missing the
> replacement of kernel_thread() by kthread_run() and the elimination of
> daemonize().

It looks like patches 3 and 4 of this patchset are too large to be
accepted by the linux-ia64 mailing list (whereas they both do appear
on the linux-kernel mailing list).

  -rw-r--r-- 1 dcn os1 204460 2008-03-26 16:36 generic-xp	<<< [Patch 3/5]
  -rw-r--r-- 1 dcn os1 163339 2008-03-26 16:36 Lindent		<<< [Patch 4/5]

So what do I do about them? I'm assuming I need to re-submit the patchset
with these two large patches broken up into multiple smaller patches?
What's the max patch size accepted by linux_ia64 mailing list?

Thanks,
Dean

