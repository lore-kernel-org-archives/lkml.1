Return-Path: <linux-kernel-owner+w=401wt.eu-S1766496AbXECUfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766496AbXECUfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766493AbXECUfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:35:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:40178 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031206AbXECUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:35:08 -0400
Date: Thu, 3 May 2007 22:34:52 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
In-Reply-To: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705032232450.18504@yvahk01.tjqt.qr>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 22:25, Øyvind Vågen Jægtnes wrote:
>
> Now for the real setup.
> We closed the mac of the juniper to the network card that
> would be connected to the internal LAN, set up the interfaces,
> and swapped cables. This worked fine for approximately 100
> of the computers that are connected, but the rest would not
> get IP. The connected 100 computers were routed just fine.

Try tcpdump. See if dhcpd actually hands out leases, and
run another tcpdump on a dhcp client machine, to see if it
even arrives. Furthermore, you could

> 193.239.155.118          ether   00:0A:E4:59:75:66   C
> eth1.1087
> 193.239.154.74                   (incomplete)
> eth1.1016

check if eth1.1016 even "works", by
  ping -bf 255.255.255.255 -I eth1.1016
if it lights up in the correct places, packets must be flowing.


Jan
-- 
