Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXKWNNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXKWNNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 08:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbXKWNNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 08:13:42 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43115 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbXKWNNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 08:13:42 -0500
Date: Fri, 23 Nov 2007 18:42:50 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Don't forget to unlock uids_mutex on error paths
Message-ID: <20071123131250.GA5771@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <47440D3D.3040609@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47440D3D.3040609@openvz.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 01:49:33PM +0300, Pavel Emelyanov wrote:
> The commit
> 
> commit 5cb350baf580017da38199625b7365b1763d7180
> Author: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Date:   Mon Oct 15 17:00:14 2007 +0200
> 
>     sched: group scheduling, sysfs tunables
> 
> introduced the uids_mutex and the helpers to lock/unlock it.
> Unfortunately, the error paths of alloc_uid() were not patched
> to unlock it.
> 

Thanks for catching it. Looks good to me. Ingo, could you please pick
these up?

> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

-- 
regards,
Dhaval
