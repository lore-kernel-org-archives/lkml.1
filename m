Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbXJDMCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbXJDMCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXJDMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:01:59 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42413 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1754145AbXJDMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:01:58 -0400
Message-ID: <4704D750.6010207@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:06:40 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 3/6] Xilinxfb: rename failout labels to reflect failure
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155743.6114.558.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155743.6114.558.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Labels and gotos are used in xilinxfb_assign to unwind allocations
> on device registration failures.  Rename the labels to reflect the
> error which occured.  This change is being made to make it easier
> to add new failout paths (which occurs in a subsuquent patch) and
> to make reviewing the failout path easier.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

>  drivers/video/xilinxfb.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
