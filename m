Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXJDMBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXJDMBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXJDMBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:01:34 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42365 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1757575AbXJDMBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:01:33 -0400
Message-ID: <4704D737.4010003@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:06:15 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 2/6] Xilinxfb: Replace calls to printk with dev_dbg, dev_err,
 etc.
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155738.6114.51384.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155738.6114.51384.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> The dev_dbg, dev_err, etc functions provide more context that plain
> vanilla printk which is useful for debugging.  Where appropriate,
> change printk calls to the appropriate dev_*() call.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

>  drivers/video/xilinxfb.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
