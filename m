Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbXKWMak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbXKWMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXKWMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:30:32 -0500
Received: from www.tglx.de ([62.245.132.106]:59489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXKWMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:30:31 -0500
Date: Fri, 23 Nov 2007 13:30:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: NOHZ: local_softirq_pending 20
In-Reply-To: <20071123112442.GA12047@bre-cln-ukleine.digi.com>
Message-ID: <alpine.LFD.0.9999.0711231323490.26417@localhost.localdomain>
References: <20071123112442.GA12047@bre-cln-ukleine.digi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-690791884-1195821016=:26417"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-690791884-1195821016=:26417
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 23 Nov 2007, Uwe Kleine-König wrote:
> my kernel reported:
> 
> 	NOHZ: local_softirq_pending 20

Thats TASKLET_SOFTIRQ
 
> I cannot interpret it, but probably this is bad, because before
> bc5393a6c9c0e70b4b43fb2fb63e3315e9a15c8f this used to BUG().

We removed the BUG, because it's a situation where the kernel can
easily recover. It should never happen that the kernel goes to sleep
with a pending softirq, but it's not a fatal error.

> This happend while having a high load.  Up to now it only happend once
> and I cannot reproduce it.

That's hard to tell then. Without a reproducible test case I can not
do much to help debugging this.

   tglx
--8323328-690791884-1195821016=:26417--
