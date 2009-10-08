Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZJHEgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZJHEgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 00:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZJHEgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 00:36:46 -0400
Received: from msr25.hinet.net ([168.95.4.125]:46942 "EHLO msr25.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZJHEgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 00:36:45 -0400
Message-ID: <4ACD6C69.7040206@wytron.com.tw>
Date: Thu, 08 Oct 2009 12:36:57 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, thierry.reding@avionic-design.de,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
References: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw> <4ACD585B.5080106@gmail.com>
In-Reply-To: <4ACD585B.5080106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 11:11 AM, Eric Dumazet wrote:
> Thomas Chou a écrit :
> You should do :
>
> size -= 4; /* strip the CRC */
> skb = netdev_alloc_skb(dev, size + NET_IP_ALIGN);
> if (skb) {
> 	skb_reserve(skb, NET_IP_ALIGN);
> 	...
> }
>
>
> Please check other implementations...
>
> David, maybe we should add following helper :
>
> [PATCH] net: Add netdev_alloc_skb_ip_align() helper

Hi Eric,

Thanks for the suggestion. I will follow your commit and send revised patch.

- Thomas
