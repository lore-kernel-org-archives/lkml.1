Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0BUBzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 20:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0BUBzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 20:55:31 -0500
Message-ID: <4B80935E.5040901@redhat.com>
Date: Sun, 21 Feb 2010 09:58:54 +0800
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
References: <1266532210-11536-1-git-send-email-opurdila@ixiacom.com> <4B7F993C.9000007@redhat.com> <201002201557.04427.opurdila@ixiacom.com>
In-Reply-To: <201002201557.04427.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Saturday 20 February 2010 10:11:40 you wrote:
> 
>> 2) I hope you could add some documentation to show the relations
>>     between ip_local_port_range and ip_local_reserved_ports.
>>
> 
> How does this sound:
> 
> ip_local_reserved_ports - list of comma separated ranges
>         Specify the ports which are reserved for known third-party
>         applications. These ports will not be used by automatic port
>         assignments (e.g. when calling connect() or bind() with port
>         number 0). Explicit port allocation behavior is unchanged.
> 
>         The format used for both input and output is a comma separated
>         list of ranges (e.g. "1,2-4,10-10" for ports 1, 2, 3, 4 and
>         10). Writing to the file will clear all previously reserved
>         ports and update the current list with the one given in the
>         input.
> 
>         Note that ip_local_port_range and ip_local_port_range settings
>         are independent and both are considered by the kernel when
>         determining which ports are available for automatic port
>         assignments.
> 
>         You can reserve ports which are not in the current
>         ip_local_port_range, e.g.:
> 
>         $ cat /proc/sys/net/ipv4/ip_local_port_range
>         32000   61000
>         $ cat /proc/sys/net/ipv4/ip_local_reserved_ports
>         8080,9148
> 
>         although this is redundant. However such a setting is useful
>         if later the port range is changed to a value that will
>         include the reserved ports.

This looks fine for me.

Thanks.

