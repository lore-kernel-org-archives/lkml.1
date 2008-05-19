Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYESQtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYESQtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYESQtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:49:45 -0400
Received: from www.tglx.de ([62.245.132.106]:55342 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYESQto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:49:44 -0400
Date: Mon, 19 May 2008 18:48:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stas Sergeev <stsp@aknet.ru>
cc: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] snd-pcsp: use HRTIMER_CB_SOFTIRQ
In-Reply-To: <4831ACCB.70302@aknet.ru>
Message-ID: <alpine.LFD.1.10.0805191848150.18798@apollo.tec.linutronix.de>
References: <4831ACCB.70302@aknet.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Stas Sergeev wrote:

> Change HRTIMER_CB_IRQSAFE to HRTIMER_CB_SOFTIRQ,
> as suggested by Thomas Gleixner.
> That solves the lock dependancy reported in
> Bug #10701.
> That also allows to call hrtimer_start()
> directly, tasklet "stupid hack" removed.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>

Looks sane.

Acked-by: Thomas Gleixner <tglx@linutronix.de> 
