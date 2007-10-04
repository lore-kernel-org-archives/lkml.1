Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbXJDJMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbXJDJMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXJDJM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:12:28 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6636 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbXJDJM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:12:26 -0400
X-IronPort-AV: i="4.21,228,1188792000"; 
   d="scan'208"; a="41086454:sNHT29288098"
Subject: Re: Blackfin Ethernet MAC driver compile error
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Kalle Pokki <kalle.pokki@iki.fi>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bryan.wu@analog.com
In-Reply-To: <a425f86c0710020430o3507eeb2veb104dc936f230dd@mail.gmail.com>
References: <a425f86c0710020430o3507eeb2veb104dc936f230dd@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 04 Oct 2007 17:12:21 +0800
Message-Id: <1191489141.6139.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 04 Oct 2007 09:12:25.0060 (UTC) FILETIME=[ADB1CA40:01C80666]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 19:30 +0800, Kalle Pokki wrote:
> The Blackfin Ethernet MAC driver does not compile. It seems the driver
> is 
> missing some pinmux defines.
> 
>   CC      drivers/net/bfin_mac.o 
> drivers/net/bfin_mac.c: In function 'setup_pin_mux': 
> drivers/net/bfin_mac.c:275: error: 'P_MII0' undeclared (first use in 
> this function) 
> drivers/net/bfin_mac.c:275: error: (Each undeclared identifier is 
> reported only once 
> drivers/net/bfin_mac.c:275: error: for each function it appears in.) 
> drivers/net/bfin_mac.c:279: error: implicit declaration of function 
> 'peripheral_request_list' 
> drivers/net/bfin_mac.c:285: error: implicit declaration of function 
> 'peripheral_free_list' 
> make[2]: *** [drivers/net/bfin_mac.o] Error 1 
> make[1]: *** [drivers/net] Error 2 
> make: *** [drivers] Error 2
> 
Sorry for missing the pinmux patches.
After Linus's git-pull, it should be fixed in the latest Linus mainline
git tree.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=66b1f1a982bf4dbad9fa0de25b8d95c4936f05c4

Thanks a lot
-Bryan
