Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYBKI4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYBKI4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYBKI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:56:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:43750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbYBKI4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:56:08 -0500
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the RTC is BCD
Date: Mon, 11 Feb 2008 09:56:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110956.16004.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Nothing ever defines RTC_PORT and RTC_ALWAYS_BCD
>
> So we can get rid of that stuff completely.

Please see the second version of the patch series. This means I didn't drop it 
completely, but added a warning about it not agreeing with the status 
register. If this warning never triggers it can be dropped eventually,
if it triggers RTC_ALWAYS_BCD should be unset.

-Andi
