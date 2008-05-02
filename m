Return-Path: <linux-kernel-owner+w=401wt.eu-S933957AbYEBKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbYEBKwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760922AbYEBKwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:52:42 -0400
Received: from web30101.mail.mud.yahoo.com ([209.191.69.33]:31680 "HELO
	web30101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759066AbYEBKwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:52:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=PfNhdsGtI3l5UFDoFnkA5FAVr5rkRfIwYpujduaKX9jX2Z1b5KBGfU8qs7VCZgXmUVH7cU02HXEFwiOkOH926VAECS5pBSM+qIYy4a5f40mXtzavdQfVNfknrtiV5msLm6tzee7HNEQpYJkXBGYbc5xQRpr25s2/kO1EyN6W2zk=;
X-YMail-OSG: BoUpPoQVM1ka5dbSziVU5iZdPdo72TvAvrdIb5WZUrb1UzHKPCR54Qj7eO4CRSW_9hVq2dUW5d8oqZnC3oQ4crufgp5BeSz_zxZT6d5vvM6b2bdXROQQG2CCpg--
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 03:52:40 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: motive for sending Ethernet packets in soft-irq context
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <95309.72215.qm@web30101.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the motive behind sending Ethernet packets to the NIC driver by invoking hard_xmit() in the soft-irq context?

What I understand is,
It is not done into the process context of send() system call beacause,
1. Calling it in soft-irq context eliminates any delays incurred by the process switching, lower task priorities etc.

Can't it be done by raising the process priority to highest until the NIC driver hand over the packet to the hardware?
This will avoid time incurred in process to soft-irq switching time.

Are there any other performance, security reasons?

Regards,
Parav Pandit


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
