Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYG2Wkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYG2Wkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbYG2Wkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:40:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57809 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYG2Wkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:40:42 -0400
Date: Wed, 30 Jul 2008 08:40:41 +1000
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] kdump: use is_kdump_kernel() in sba_init()
Message-ID: <20080729224039.GE6370@verge.net.au>
References: <20080729081235.293361145@vergenet.net> <20080729081629.356523305@vergenet.net> <20080729145156.GO25975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729145156.GO25975@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:51:56AM -0400, Vivek Goyal wrote:
> On Tue, Jul 29, 2008 at 06:12:36PM +1000, Simon Horman wrote:
> > After recent patches* is_kdump_kernel() should return 1 in the
> > case where code is executing in a crashkernel and 0 otherwise.
> > It is save to use outside of CONFIG_KDUMP.
> > 
> > * http://lkml.org/lkml/2008/7/28/445
> > 
> 
> Hi Simon,
> 
> is_kdump_kernel() returns 1 when both the following conditions are true.
> 
> - CONFIG_CRASH_DUMP is enabled
> - And kernel is booting after a panic.
> 
> If any of the above condition is not true, it returns 0.
> 
> So for the cases where, CONFIG_CRASH_DUMP=n and kernel is booting after
> panic, is_kdump_kernel() will still return 0.
> 
> This essentially means that any kernel which is booting after a panic,
> but does not have CONFIG_CRASH_DUMP enabled, will not take special actions
> required for booting that kernel. Until, somebody can come up with another
> usage of booting a kernel after a panic (apart from crash dump), I think
> this is good enough an assumption.
> 
> So your changes will work. I just wanted to clarify the semantics more
> explicitly.

Hi Vivek,

sorry if my explanation was confused. The scheme that you describe
above is what I am working with too.

-- 
Horms

