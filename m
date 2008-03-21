Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYCUOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYCUOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYCUOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:39:31 -0400
Received: from www.tglx.de ([62.245.132.106]:43084 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYCUOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:39:30 -0400
Date: Fri, 21 Mar 2008 15:15:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roman Zippel <zippel@linux-m68k.org>, johnstul@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] handle leap second via timer
In-Reply-To: <20080317151856.adea0488.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803211513120.3781@apollo.tec.linutronix.de>
References: <20080314184001.695807682@linux-m68k.org> <20080314195737.212526899@linux-m68k.org> <1205526244.6122.5.camel@localhost.localdomain> <Pine.LNX.4.64.0803150417540.1791@scrub.home> <20080317151856.adea0488.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Andrew Morton wrote:
> It sounds like a few updates are in the pipeline, but I merged this series
> as-is into -mm.
> 
> I'll normally push ntp changes through Thomas's git-hrt tree, however this
> patch series has dependencies upon at least
> 
> introduce-explicit-signed-unsigned-64bit-divide.patch
> convert-a-few-do_div-user.patch
> rename-div64_64-to-div64_u64.patch
> rename-div64_64-to-div64_u64-mm.patch
> remove-div_long_long_rem.patch
> 
> so they can't go into git-hrt immediately.
> 
> The idealised algorithm is
> 
> - 2.6.26 opens
> - Thomas merges git-hrt
> - I merge the above patches
> - I then send these ntp patches to Thomas
> - He merges them into git-hrt
> - He does another git-hrt -> Linus merge
> 
> And that's all OK, but various lags might cause us to miss the merge
> window, as I merge the -mm stuff last, and some git-tree maintainers are
> dawdlers.

:)

> So if Thomas wants to ack these I can merge them directly late in the
> 2.6.26 merge window.

Fine for me either way.

Thanks,

	tglx

