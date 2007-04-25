Return-Path: <linux-kernel-owner+w=401wt.eu-S2992869AbXDYSfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992869AbXDYSfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992883AbXDYSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:35:18 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:16065 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992869AbXDYSfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:35:17 -0400
X-IronPort-AV: i="4.14,451,1170662400"; 
   d="scan'208"; a="372170063:sNHT44918774"
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, mst@mellanox.co.il,
       jackm@mellanox.co.il
Subject: Re: pgprot_writecombine() and PATs on x86
X-Message-Flag: Warning: May contain useful information
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de>
	<m1abwws3uh.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 25 Apr 2007 11:35:15 -0700
In-Reply-To: <m1abwws3uh.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Wed, 25 Apr 2007 12:31:34 -0600")
Message-ID: <adaodlcwbdo.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2007 18:35:15.0305 (UTC) FILETIME=[7768BD90:01C78768]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland is the mlx4 sane enough to put the memory that needs
 > write-combining a prefetchable bar.  So several cards can be combined
 > together?

Yes, it is in a prefetchable BAR.  It's the second half of the second
BAR in:

    0d:00.0 InfiniBand: Mellanox Technologies Unknown device 634a (rev a0)
            Subsystem: Mellanox Technologies Unknown device 634a
            Flags: bus master, fast devsel, latency 0, IRQ 16
            Memory at fc400000 (64-bit, non-prefetchable) [size=1M]
            Memory at d8000000 (64-bit, prefetchable) [size=8M]
            Memory at fc3fe000 (64-bit, non-prefetchable) [size=8K]
            Capabilities: <access denied>

but I'm not sure what you mean about combining several cards?

 - R.
