Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbXJDMCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbXJDMCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbXJDMC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:02:26 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42506 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1758679AbXJDMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:02:25 -0400
Message-ID: <4704D769.8090207@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:07:05 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 4/6] xilinxfb: Split device setup from bus binding
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155748.6114.39929.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155748.6114.39929.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Split the device setup code away from the platform bus binding.  This is
> in preparation for adding the of_platform bus binding to this driver and
> most of the setup code is common between the two busses.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

>  drivers/video/xilinxfb.c |  133 ++++++++++++++++++++++++++++------------------
>  1 files changed, 80 insertions(+), 53 deletions(-)
