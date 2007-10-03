Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbXJCQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbXJCQr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXJCQrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:47:20 -0400
Received: from waste.org ([66.93.16.53]:37430 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbXJCQrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:47:19 -0400
Date: Wed, 3 Oct 2007 11:42:58 -0500
From: Matt Mackall <mpm@selenic.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 2/3] Prepare pid_nr() etc functions to work with not-NULL pids
Message-ID: <20071003164258.GS19691@waste.org>
References: <4703A44F.9020402@openvz.org> <4703A53B.9090804@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4703A53B.9090804@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 06:20:43PM +0400, Pavel Emelyanov wrote:
> Just make the __pid_nr() etc functions that expect the argument
> to always be not NULL.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

>  static inline pid_t pid_nr(struct pid *pid)
>  {
>  	pid_t nr = 0;
>  	if (pid)
> -		nr = pid->numbers[0].nr;
> +		nr = __pid_nr(pid);
>  	return nr;
>  }

Is there a patch that removes these inlines? Otherwise this looks good
to me.

--
Mathematics is the supreme nostalgia of our time.
