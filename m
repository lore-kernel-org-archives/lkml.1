Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZCSGpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZCSGpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbZCSGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:45:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759034AbZCSGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:45:04 -0400
Date: Wed, 18 Mar 2009 23:44:51 -0700 (PDT)
Message-Id: <20090318.234451.38898787.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: next-20090318: sunhme does not transmit packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
References: <a4423d670903180734w7270a4f3qa2af3981b969436c@mail.gmail.com>
	<a4423d670903180958j4847717eh99a41534633dd314@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Wed, 18 Mar 2009 19:58:40 +0300

> 2009/3/18 Alexander Beregalov <a.beregalov@gmail.com>:
> > Hi
> >
> > Ultra 10 can boot, it receives DHCP answer, ssh works, but few minutes
> > after machine becomes unresponsible by net at all.
> > It does not respond even on ARP requests.
> >
> > On Sparc host I see that `TX packets` does not grow, but RX grows.
> > The state of the interface is
> > UP BROADCAST RUNNING MULTICAST
> >
> > There is no relevant kernel messages in dmesg.
> >
> > next-20090317 worked fine.
> >
> >
> > Let me know if I can help.
> >
> 
> I have reproduced it on next-20090318 for the second time, but still
> do not know how.
> next-20090317 might be affected.
> 
> Now both packet counters grow, but tcpdump cannot capture any packet.

Does the current vanilla kernel work fine?
