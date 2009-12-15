Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbZLOVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbZLOVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbZLOVwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:52:18 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57373 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761168AbZLOVwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:15 -0500
Date: Tue, 15 Dec 2009 22:52:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       rientjes@google.com
Subject: Re: kexec boot regression
Message-ID: <20091215215214.GF28252@kernel.dk>
References: <20091215201909.GY28252@kernel.dk> <4B27EFC2.1000505@kernel.org> <20091215204221.GZ28252@kernel.dk> <20091215205512.GA28252@kernel.dk> <20091215210126.GB28252@kernel.dk> <4B27FEFB.30902@kernel.org> <20091215213032.GC28252@kernel.dk> <20091215214009.GD28252@kernel.dk> <4B2802E4.40404@kernel.org> <20091215214743.GE28252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215214743.GE28252@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Jens Axboe wrote:
> > oh, i post one patch last week, 
> > 
> > can you check it?
> 
> Sure, let me try it. I already found out that commit 8716273c is the
> guilty one (x86: Export srat physical topology).

Confirmed, -git with that patch works as well. So that's all of them I
think, can we please get this expedited in so that -rc1 will work?
Thanks!

-- 
Jens Axboe

