Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0BTN00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:26:26 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:2994 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755085Ab0BTN0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:26:25 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v5 3/3] net: reserve ports for applications using fixed port numbers
Date: Sat, 20 Feb 2010 15:27:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com> <1266532210-11536-3-git-send-email-opurdila@ixiacom.com> <4B7F9B65.1060309@redhat.com>
In-Reply-To: <4B7F9B65.1060309@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201527.37643.opurdila@ixiacom.com>
X-OriginalArrivalTime: 20 Feb 2010 13:26:23.0777 (UTC) FILETIME=[4C0FF910:01CAB230]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 February 2010 10:20:53 you wrote:

> > +unsigned long *sysctl_local_reserved_ports;
> > +EXPORT_SYMBOL(sysctl_local_reserved_ports);
> > +
> 
> Sorry, this looks somewhat weird, why not just export
> inet_is_reserved_local_port()?
> 

My understanding is that if we do that than we won't be able to inline 
inet_is_reserved_local_port().  And as David said previously that will have a 
significant impact on performance.
