Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYCUJxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYCUJxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYCUJxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:53:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31701 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYCUJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:53:37 -0400
Date: Fri, 21 Mar 2008 10:53:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Michael Buesch <mb@bu3sch.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321105311.1a55cc0f@hyperion.delvare>
In-Reply-To: <20080320201723.b87b3732.akpm@linux-foundation.org>
References: <20080320192719.6a32386e.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
	<20080320201723.b87b3732.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 20:17:23 -0700, Andrew Morton wrote:
> in_atomic() is for core kernel use only.  (...)

Then why is it made available to drivers through <linux/hardirq.h>? If
it's such a dangerous macro to call from drivers, it shouldn't be made
available, or at the very least there should be a big fat warning in
<linux/hardirq.h> that drivers aren't supposed to use it. This would
have avoided the 23 uses cases in drivers we have right now.

-- 
Jean Delvare
