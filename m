Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXJDMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXJDMAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXJDMAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:00:22 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42157 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1755277AbXJDMAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:00:20 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 08:00:20 EDT
Message-ID: <4704D87E.30104@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:11:42 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 6/6] Xilinxfb: add of_platform bus binding
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Adds the of_platform bus binding to the xilinxfb driver.  Needed to
> use framebuffer devices described in the OF device tree (used by
> arch/powerpc).
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

Assuming the issue with error handling in xilinxfb_init() pointed out by
Akinobu Mita is fixed.

>  drivers/video/xilinxfb.c |  101 ++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 93 insertions(+), 8 deletions(-)
