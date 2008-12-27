Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYL0Amk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYL0Amk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYL0Amb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:42:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbYL0Ama (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:42:30 -0500
Date: Fri, 26 Dec 2008 16:41:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Soekris net5501 board support code
Message-Id: <20081226164156.371a8b14.akpm@linux-foundation.org>
In-Reply-To: <20081226022602.342db591@i1501.lan.towertech.it>
References: <20081226022602.342db591@i1501.lan.towertech.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 02:26:02 +0100 Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

>  This patch detects the net5501 board and instantiates the
>  correct platform devices (GPIO and leds).
> 
>  Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
> 
> ---
>  arch/x86/Kconfig          |    9 +++
>  arch/x86/kernel/Makefile  |    1 
>  arch/x86/kernel/soekris.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++

You might want to tell the x86 maintainers about this :)
