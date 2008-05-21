Return-Path: <linux-kernel-owner+w=401wt.eu-S1765448AbYEUWeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765448AbYEUWeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYEUWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbYEUWeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:34:04 -0400
Date: Wed, 21 May 2008 15:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stas Sergeev <stsp@aknet.ru>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org
Subject: Re: [patch] provide rtc_cmos platform device
Message-Id: <20080521153223.e989cb88.akpm@linux-foundation.org>
In-Reply-To: <483317B4.7060601@aknet.ru>
References: <483317B4.7060601@aknet.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 22:25:56 +0400
Stas Sergeev <stsp@aknet.ru> wrote:

> Hello.
> 
> Recently (around 2.6.25) I've noticed
> that RTC no longer works for me.

So it's a regression.

> It turned out this is because I use
> pnpacpi=off kernel option to work
> around the parport_pc bugs.
> I always did so, but RTC used to work
> fine in the past, and now it have
> regressed.

Albeit a fairly obscure one.  I tagged the patch for backporting, let
those guys decide ;)

> The attached patch fixes the problem
> by creating the platform device for
> the RTC when PNP is disabled.
> This may also help running the
> PNP-enabled kernel on an older PCs.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>

I suppose that on this basis:

 arch/x86/kernel/rtc.c  |   31 +++++++++++++++++++++++++++++++
 drivers/rtc/rtc-cmos.c |   26 +++++++++-----------------
 include/asm-x86/rtc.h  |    4 ++++

it should be considered an x86 patch.  I shall treat it as such.

Thanks.
