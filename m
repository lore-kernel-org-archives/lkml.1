Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXDZFnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXDZFnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbXDZFnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:43:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbXDZFna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:43:30 -0400
Date: Thu, 26 Apr 2007 08:43:33 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jack Morgenstein <jackm@mellanox.co.il>
Subject: Re: pgprot_writecombine() and PATs on x86
Message-ID: <20070426054333.GN5217@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <ada1wi8xrgt.fsf@cisco.com> <adaodlcwbdo.fsf@cisco.com>
	<m11wi8s36o.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wi8s36o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So in general the pci prefetchable attribute means write-combining as
> well as prefetching is safe.  A sane BIOS will allocate prefetchable
> BARS contiguously in the address space.  So on a good day you
> can just use one MTRR to map all of the prefetchable BARs as write-combining.

Good point, and sounds easy enough.
So why does not linux do it automatically then where possible?

There are sure to be some broken devices, but if some device
can't live with WC, we can always disable WC system-wide.

-- 
MST
