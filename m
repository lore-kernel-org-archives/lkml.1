Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0BDSTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:19:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab0BDSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:19:04 -0500
Date: Thu, 04 Feb 2010 10:19:16 -0800 (PST)
Message-Id: <20100204.101916.180396428.davem@davemloft.net>
To: hadi@cyberus.ca
Cc: s.L-H@gmx.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265307247.4651.2.camel@bigi>
References: <1265282011.4204.12.camel@bigi>
	<201002041850.31310.s.L-H@gmx.de>
	<1265307247.4651.2.camel@bigi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jamal <hadi@cyberus.ca>
Date: Thu, 04 Feb 2010 13:14:07 -0500

> On Thu, 2010-02-04 at 18:50 +0100, Stefan Lippers-Hollmann wrote:
>> sysctl table check failed
> 
> Can you look at your patched source include/linux/sysctl.h
> and see whether you see the following lines:
> ----
>         NET_IPV4_CONF_ARP_ACCEPT=21,
>         NET_IPV4_CONF_ARP_NOTIFY=22,
>         NET_IPV4_CONF_ACCEPT_LOCAL=23,
>         NET_IPV4_CONF_SRC_VMARK=24,
>         __NET_IPV4_CONF_MAX
> ---
> 
> I have a feeling you are missing NET_IPV4_CONF_ACCEPT_LOCAL

Do they really have to be contiguous?  That's a strange
requirement.

Yes, NET_IPV4_CONF_ACCEPT_LOCAL isn't there.
