Return-Path: <linux-kernel-owner+w=401wt.eu-S1763176AbXGRO7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763176AbXGRO7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXGRO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:59:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbXGRO72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:59:28 -0400
Message-ID: <469E2AAB.2010408@redhat.com>
Date: Wed, 18 Jul 2007 10:58:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Peter Osterlund <petero2@telia.com>
CC: linux-kernel@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
       "John W. Linville" <linville@tuxdriver.com>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: Occational lockups during boot with post 2.6.22 kernels
References: <m3sl7mk1f1.fsf@telia.com>
In-Reply-To: <m3sl7mk1f1.fsf@telia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 08:20 PM, Peter Osterlund wrote:
> Current -git kernels sometimes lock up on my computer during boot. I
> guess it happens about 10-20% of the time. I first saw this maybe a
> week ago, but never with kernels <= 2.6.22.
> 
> The last reported info on the console is that named is started.
> SysRq-T still works and reports the non-sleeping tasks below.
> 
> My guess is that wpa_supplicant and events/0 deadlock and later the
> named thread also hangs when it needs a deadlocked resource.
> 
> I'm using the bcm43xx driver.
>  
> No lockdep errors are reported before the lockup. Earlier during boot
> the kernel reports:
> 
>   Good, all 218 testcases passed! |

Try this, it should at least detect the problem:

http://lkml.org/lkml/2007/7/17/202
http://lkml.org/lkml/2007/7/17/204
http://lkml.org/lkml/2007/7/17/203

It's a known bug in wireless/80211, not sure when it will be fixed.
