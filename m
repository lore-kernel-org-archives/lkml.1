Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZLWTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZLWTvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZLWTu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:50:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbZLWTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:50:53 -0500
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Kyle Moffett <kyle@moffetthome.net>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
From: Andi Kleen <andi@firstfloor.org>
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu>
	<4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu>
	<4B3103B4.4070708@gmail.com>
	<f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com>
	<4B3254B4.2080602@gmail.com> <20091223192808.GA30700@ovro.caltech.edu>
Date: Wed, 23 Dec 2009 20:50:52 +0100
In-Reply-To: <20091223192808.GA30700@ovro.caltech.edu> (Ira W. Snyder's message of "Wed, 23 Dec 2009 11:28:08 -0800")
Message-ID: <873a31cvvn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ira W. Snyder" <iws@ovro.caltech.edu> writes:

> (You'll quickly find that you must use DMA to transfer data across PCI.
> AFAIK, CPU's cannot do burst accesses to the PCI bus. I get a 10+ times

AFAIK that's what write-combining on x86 does. DMA has other
advantages of course.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
