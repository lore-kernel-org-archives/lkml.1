Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXGEGj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXGEGj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbXGEGjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:39:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16664 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbXGEGjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:39:45 -0400
Date: Wed, 4 Jul 2007 23:39:05 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 5/9] netconsole: Introduce dev_status member
Message-ID: <20070705063904.GG17650@tasint.org>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Keiichi Kii <k-keiichi@bx.jp.nec.com>,
	Netdev <netdev@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110804.28520.25792.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704110804.28520.25792.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 04:38:04PM +0530, Satyam Sharma wrote:
> -	if (!(event == NETDEV_CHANGEADDR || event == NETDEV_CHANGENAME))
> -		goto done;
> +	if (!(event == NETDEV_UP || event == NETDEV_DOWN ||
> +	      event == NETDEV_CHANGEADDR || event == NETDEV_CHANGENAME))
> +	      	goto done;
>
>  	if (nt->np.dev == dev) {
>  		switch (event) {

	It's a small nit, but isn't the large if() just the degenerate
default case of the switch()?  Why have it at all?  

Joel

-- 

Life's Little Instruction Book #396

	"Never give anyone a fruitcake."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
