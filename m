Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYCYUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYCYUF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCYUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:05:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbYCYUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:05:19 -0400
Date: Tue, 25 Mar 2008 15:05:17 -0500
From: Dean Nelson <dcn@sgi.com>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: jes@sgi.com, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [Patch 5/5] run drivers/misc/xp through scripts/checkpatch.pl
Message-ID: <20080325200517.GA4446@sgi.com>
References: <20080325192524.343385569@attica.americas.sgi.com> <20080325192558.959273025@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325192558.959273025@attica.americas.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 02:25:29PM -0500, dcn@sgi.com wrote:
> 
> Addressed issues raised by scripts/checkpatch.pl. Removed unnecessary curly
> braces.  Eliminated uses of volatiles and use of kernel_thread() and
> daemonize().
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 

Forgot to mention that scripts/checkpatch.pl gave 15 false positives of
the following type against drivers/misc/xp/xp_main.c.

> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #48: FILE: misc/xp/xp_main.c:48:
> +EXPORT_SYMBOL_GPL(xp_remote_memcpy);

The fact is that the EXPORT_SYMBOL(xp_remote_memcpy) does immediately follow
the function/variable as follows.

enum xp_retval (*xp_remote_memcpy) (void *dst, const void *src, size_t len);
EXPORT_SYMBOL_GPL(xp_remote_memcpy);

