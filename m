Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYEOTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYEOTv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbYEOTus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:50:48 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4818 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbYEOTuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:50:46 -0400
Date: Thu, 15 May 2008 15:16:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zd1211rw: Use DMA-aware buffer for usb transfer
Message-ID: <20080515191647.GB17690@tuxdriver.com>
References: <20080516.001215.39152691.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516.001215.39152691.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:12:15AM +0900, Atsushi Nemoto wrote:
> The zd1211rw driver uses unaligned stack buffer for USB control
> message.  But it might cause stack corruption on non-coherent
> platform, such as MIPS.  Use DMA-aware buffers for USB transfer.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Nemoto,

This looks like a reasonable fix to me.  I would prefer to see a
comment in the code indicating why you are reusing the "p" buffer
instead of simply using "ret" directly.  Also, I think the style
suggestion by Michael Buesch would make the code appear more idiomatic
as well.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
