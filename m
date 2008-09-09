Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYIIMjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYIIMjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYIIMjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:39:00 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:2154 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYIIMi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:38:59 -0400
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] __tick_program_event of hpet is stuck
Date: Tue, 9 Sep 2008 14:38:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200809080114.36106.elendil@planet.nl> <200809080313.48910.elendil@planet.nl> <alpine.LFD.1.10.0809091248590.3271@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809091248590.3271@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091438.57158.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2008 12:38:57.0837 (UTC) FILETIME=[073A3DD0:01C91279]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008, Thomas Gleixner wrote:
> > CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
> > CE: increasing min_delta_ns 5000 to 10000 nsec
> > [...]
> > CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
> > CE: increasing min_delta_ns 10000 to 20000 nsec
> > [...]
> > CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
> > CE: increasing min_delta_ns 20000 to 40000 nsec
>
> what's the highest value which you have seen ?

These are the highest I've seen, but that's possibly because I haven't 
left the system running for longer. There's just under an hour between 
the messages (kern.log has 00:59:17, 01:56:38, 02:51:23 for the three 
increases listed above) with the first fairly shortly after boot.

I've just awakened the laptop from suspend and will let it sit for the 
rest of the day. If I get any higher values I'll let you know.
