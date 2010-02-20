Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0BTINX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:13:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0BTINU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:13:20 -0500
Message-ID: <4B7F993C.9000007@redhat.com>
Date: Sat, 20 Feb 2010 16:11:40 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v5 0/3] net: reserve ports for applications using
 fixed port numbers
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com>
In-Reply-To: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports which
> allows users to reserve ports for third-party applications.
> 
> The reserved ports will not be used by automatic port assignments
> (e.g. when calling connect() or bind() with port number 0). Explicit
> port allocation behavior is unchanged.
> 
> Changes from the previous version:
> - switch the /proc entry format to coma separated list of range ports
> - treat -EFAULT just like any other error and acknowledge written values
> - use isdigit() in proc_get_ulong
> 
> Octavian Purdila (3):
>   sysctl: refactor integer handling proc code
>   sysctl: add proc_do_large_bitmap
>   net: reserve ports for applications using fixed port numbers

Hi,

This version looks fine for me, but I need to give them a test, and
I will put feedbacks asap. Thanks for your work!

Still two things:

1) bitops are always atomic on every arch, right? If yes, then ok.
2) I hope you could add some documentation to show the relations
    between ip_local_port_range and ip_local_reserved_ports.

Thanks!

