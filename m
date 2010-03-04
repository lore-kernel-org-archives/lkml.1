Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0CDJS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:18:27 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:42663 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0CDJSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:18:22 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com>
	<4B8EEB2D.4090106@zytor.com>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com>
Date: Thu, 04 Mar 2010 18:18:17 +0900
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com>
	(Daniel Taylor's message of "Wed, 3 Mar 2010 15:24:25 -0800")
Message-ID: <871vg0zbqe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Taylor" <Daniel.Taylor@wdc.com> writes:

> It is only the intermediate variables in the module that are
> currently hard-coded to 32-bits, and which truncate the values.

BTW, it may not be only 32-bits truncate issue. IIRC, e.g. some
implement is checking the 0xaa mark at the end of sector. I forgot
almost though, IIRC, Windows writes 0xaa mark to the both of "end of
sector" and "end of 512" for compatibility.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
