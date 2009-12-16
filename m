Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZLPKBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZLPKBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbZLPKBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:01:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52719 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994AbZLPKBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:01:02 -0500
Date: Wed, 16 Dec 2009 11:01:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Huang Ying <ying.huang@intel.com>, rientjes@google.com
Subject: Re: kexec boot regression
Message-ID: <20091216100100.GQ28252@kernel.dk>
References: <20091215204221.GZ28252@kernel.dk> <20091215205512.GA28252@kernel.dk> <20091215210126.GB28252@kernel.dk> <4B27FEFB.30902@kernel.org> <20091215213032.GC28252@kernel.dk> <20091215214009.GD28252@kernel.dk> <4B2802E4.40404@kernel.org> <20091215214743.GE28252@kernel.dk> <20091215215214.GF28252@kernel.dk> <4B280CBB.9090406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B280CBB.9090406@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Jens Axboe wrote:
> >>> oh, i post one patch last week, 
> >>>
> >>> can you check it?
> >> Sure, let me try it. I already found out that commit 8716273c is the
> >> guilty one (x86: Export srat physical topology).
> > 
> > Confirmed, -git with that patch works as well. So that's all of them I
> > think, can we please get this expedited in so that -rc1 will work?
> > Thanks!
> 
> updated version:
> 
> [PATCH] x86: fix checking of SRAT when node0 ram is not from 0 -v3

Verified, this one works fine, too.

-- 
Jens Axboe

