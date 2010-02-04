Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0BDSc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:32:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:43217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757282Ab0BDSc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:32:57 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+SfF5oDmuSTHxUP49iuQWmiAGTX14OM49wOIzhJX
	6xIlAcv744/vtp
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: hadi@cyberus.ca
Subject: Re: patch net-restore-ip-source-validation.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 19:31:38 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
References: <1265060041850@kroah.org> <201002041850.31310.s.L-H@gmx.de> <1265307247.4651.2.camel@bigi>
In-Reply-To: <1265307247.4651.2.camel@bigi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041931.40493.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 04 February 2010, jamal wrote:
> On Thu, 2010-02-04 at 18:50 +0100, Stefan Lippers-Hollmann wrote:
> > sysctl table check failed
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

Yes, you're 100% right - such a hunk is missing from queue-2.6.32 [1]

	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.32/net-restore-ip-source-validation.patch;h=8cc634adad59c2f67626f853e0fcce5ca8f1d579;hb=HEAD

and from 2.6.32.8-rc1 [2]

	$ wget -qO- kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.8-rc1.gz | zgrep NET_IPV4_CONF_ACCEPT_LOCAL
	$

Regards
	Stefan Lippers-Hollmann

[1]	git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
[2]	[46/74] net: restore ip source validation, Message-Id: <20100204171514.263483751@linux.site>
