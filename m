Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYFTQTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYFTQTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYFTQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:18:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYFTQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:18:53 -0400
Date: Fri, 20 Jun 2008 18:18:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Buehler <aspam@cox.net>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH]  Add PCI ID for 6300ESB force hpet
Message-ID: <20080620161837.GA23432@elte.hu>
References: <4845f281.8dQsWzXdrYDR2glC%ole@ans.pl> <g2j97o$es2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2j97o$es2$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Buehler <aspam@cox.net> wrote:

> Tested on Supermicro X6DVA-EG2.
>
> # lspci
> 00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller (rev 02)
> # lspci -n
> 00:1f.0 Class 0601: 8086:25a1 (rev 02)
>
> kernel: pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> kernel: hpet clockevent registered
> kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> kernel: hpet0: 3 64-bit timers, 14318180 Hz

applied to tip/timers/hpet. Thanks Joe,

	Ingo
