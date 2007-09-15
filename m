Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbXIOX35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbXIOX35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 19:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXIOX3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 19:29:50 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1693 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXIOX3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 19:29:49 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: CPU usage for 10Gbps UDP transfers
Date: Sat, 15 Sep 2007 16:29:39 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMECDGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070915190016.GA3868@ics.muni.cz>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 15 Sep 2007 16:30:19 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 15 Sep 2007 16:30:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello,
>
> is it expected that application sending 8900bytes datagram
> through 10Gbps NIC
> utilizes CPU to 100% and similarly the receiver also utilizes CPU to 100%.
> Is it something wrong or this is quite OK?
>
> (The box is dual single core Opteron 2.4GHz with Myricom 10GE NIC.)

It's extremely hard to understand what it is that you're saying. Perhaps if
I explain the two things I first thought when you posted this, it will
explain why your post is vague:

1) *Any* task will use the CPU to 100% while it's running. Even if you ask
the computer to add 1 to 1, while it's doing that add for you, the task is
using 100% of the CPU.

2) If you ask the CPU to do any task over and over again as quickly as it
can, and it has nothing else to do, that task will get 100% of the CPU?

So what are you really asking?

DS


