Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYGTQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYGTQQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYGTQQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:16:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:38129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYGTQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:16:35 -0400
Date: Sun, 20 Jul 2008 09:16:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Emil Medve <Emilian.Medve@Freescale.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-smp@vger.kernel.org,
       Emil Medve <Emilian.Medve@Freescale.com>
Subject: Re: [PATCH] Export irq_set_affinity()
Message-ID: <20080720091628.1f705988@infradead.org>
In-Reply-To: <1216568779-11828-1-git-send-email-Emilian.Medve@Freescale.com>
References: <1216568779-11828-1-git-send-email-Emilian.Medve@Freescale.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 10:46:19 -0500
Emil Medve <Emilian.Medve@Freescale.com> wrote:

> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> ---
> 
> This is needed for drivers built as modules and running on SMP
> systems that want to set initial/default explicit IRQ balancing

hi,

can you give an example of such a driver? It's custom to post such an
export patch as part of the patch that starts using the export...

Also... how much of this is already covered by the "don't balance" IRQ
flag already ?



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
