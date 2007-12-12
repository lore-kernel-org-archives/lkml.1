Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXLLFd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXLLFd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXLLFdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:33:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:59923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbXLLFdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:33:18 -0500
Date: Tue, 11 Dec 2007 21:35:56 -0800
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Add Documentation for FAIR_USER_SCHED sysfs files
Message-ID: <20071212053556.GA25334@suse.de>
References: <20071212023836.GB1486@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212023836.GB1486@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 08:08:36AM +0530, Dhaval Giani wrote:
> 
> This patch adds documentation about /sys/kernel/uids/<uid>/cpu_share
> to Documentation/ABI.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  Documentation/ABI/testing/sysfs-kernel-uids |   10 ++++++++++
>  1 files changed, 10 insertions(+)
> 
> Index: current/Documentation/ABI/testing/sysfs-kernel-uids
> ===================================================================
> --- /dev/null
> +++ current/Documentation/ABI/testing/sysfs-kernel-uids
> @@ -0,0 +1,10 @@
> +What:		/sys/kernel/uids/<uid>/cpu_shares
> +Date:		December 2007
> +Contact:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
> +		Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> +Description:
> +		The /sys/kernel/uids/<uid>/cpu_shares tunable is used
> +		to set the cpu bandwidth a user is allowed. This is a
> +		propotional value. What that means is that if there
> +		are two users logged in, each with shares 1024, they
> +		will get equal CPU bandwidth.

Hm, how about describing the units here?  Can you put "10" in each file
and everyone will get the same share?  100?  1?  1024 seems like an odd
"share" number.  Unless there is some other document you wish to refer
people to do help describe these values?

thanks,

greg k-h
