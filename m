Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYJWImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYJWImX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYJWImL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:42:11 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:42396 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYJWImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:42:10 -0400
Message-ID: <490038E9.7050902@lougher.demon.co.uk>
Date: Thu, 23 Oct 2008 09:42:17 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
References: <E1KqrTW-0001xC-9M@dylan> <Pine.LNX.4.64.0810221907080.20919@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0810221907080.20919@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> Sparse with endian checking (make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__") complains
> aibout these:
> 
> | fs/squashfs/inode.c:306:25: warning: cast to restricted __le16
> | fs/squashfs/inode.c:324:25: warning: cast to restricted __le16
> 
> and it seems to be right, as inode.i_mode is not __le16. I think the le16_to_cpu()
> should be removed.

Yes, you're right.  Fixed thanks.

> 
> BTW, there are also a few sparse warnings about different signednesses, so you
> probably want to run sparse yourself, too.

I'll do that.

Phillip
