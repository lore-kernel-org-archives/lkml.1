Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0BOMdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab0BOMdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:33:10 -0500
Message-ID: <4B793FC8.1050905@redhat.com>
Date: Mon, 15 Feb 2010 20:36:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>, netdev@vget.kernel.org,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [net-next PATCH v3 0/3] net: reserve ports for applications using
 fixed port numbers
References: <1265854160-11763-1-git-send-email-opurdila@ixiacom.com>
In-Reply-To: <1265854160-11763-1-git-send-email-opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> This patch series is based on Amerigo's v2 but it now uses a bitmap
> for port reservation.
> 
> I've ran a while (1) { bind(0) } test (with ip_local_port_range
> 1024 65000) to see if there is any performance difference between the
> two approaches (ranges vs bitmap). I could not detect any significant
> difference, both cases scored in 2.76s +/- 0.01 on my setup.
> 
> I've based this patch series on current net-next, but it contains a
> significant non networking part. Please let me know if I should handle
> this differently.
> 
> Octavian Purdila (3):
>   sysctl: refactor integer handling proc code
>   sysctl: add proc_dobitmap
>   net: reserve ports for applications using fixed port numbers
> 

(Sorry for the delay, we are having Chinese new year here.)

Thanks for your work, Octavian!

Your patches look nice, but I don't have much time to review them today,
I will have a detailed look tomorrow.

Thanks.
