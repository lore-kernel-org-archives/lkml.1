Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXCAEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXCAEoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 23:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXCAEoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 23:44:32 -0500
Received: from koto.vergenet.net ([210.128.90.7]:53177 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbXCAEob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 23:44:31 -0500
Date: Thu, 1 Mar 2007 13:22:27 +0900
From: Horms <horms@verge.net.au>
To: John Keller <jpk@sgi.com>
Cc: fastboot@lists.osdl.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [PATCH 1/1] - platform_kernel_launch_event is noop on generic kernel
Message-ID: <20070301042227.GO6479@verge.net.au>
References: <20070228194517.25635.98535.sendpatchset@attica.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228194517.25635.98535.sendpatchset@attica.americas.sgi.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 01:45:17PM -0600, John Keller wrote:
> Add a missing #define for the platform_kernel_launch_event.
> Without this fix, a call to platform_kernel_launch_event()
> becomes a noop on generic kernels. SN systems require this
> fix to successfully kdump/kexec from certain hardware errors.
>
> Signed-off-by: John Keller <jpk@sgi.com>

I made a similar change when porting to xen, but I hadn't thought
to see if mainline linux needs it to.

Acked-by: Simon Horman <horms@verge.net.au>

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

