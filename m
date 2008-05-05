Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbYEEUfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbYEEUfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbYEEUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:35:07 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:56576 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbYEEUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:35:06 -0400
Date: Mon, 5 May 2008 17:33:30 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clemens Ladisch <clemens@ladisch.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] #if 0 hpet_unregister()
Message-ID: <20080505203329.GA16213@beyonder.ift.unesp.br>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080505182853.GS17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505182853.GS17139@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  5.May'08 at 21:28:53 +0300, Adrian Bunk wrote:
> This patch #if 0's the unused hpet_unregister().
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: Clemens Ladisch <clemens@ladisch.de>

Hm...what about Documentation/hpet.txt, where it is written:

The kernel API has three interfaces exported from the driver:

	hpet_register(struct hpet_task *tp, int periodic)
	hpet_unregister(struct hpet_task *tp)
	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)

Maybe someone could update that file too, to help anyone who wants to
learn about hpet ( hpet_register(...) and hpet_control(...) don't even
exist anymore in the kernel)
