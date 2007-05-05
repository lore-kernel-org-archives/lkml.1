Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXEEX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXEEX20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXEEX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:28:26 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:37042 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754106AbXEEX2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:28:25 -0400
Date: Sun, 6 May 2007 03:27:47 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Message-ID: <20070506032747.07171caf@localhost.localdomain>
In-Reply-To: <20070504123543.5e3fd908.akpm@linux-foundation.org>
References: <20070503235747.29275.37271.stgit@localhost.localdomain>
	<20070504123543.5e3fd908.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1cvs42 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 12:35:43 -0700
Andrew Morton wrote:

> On Fri, 04 May 2007 03:57:51 +0400
> Vitaly Bordug <vitb@kernel.crashing.org> wrote:
> 
> > 
> > Adds support for PowerQuicc on-chip PCMCIA. The driver is
> > implemented as of_device, so only arch/powerpc stuff is capable to
> > use it, which now implies only mpc885ads reference board.
> > 
> > To cope with the code that should be hooked inside driver, but is
> > really board specific (like set_voltage), global structure
> > mpc8xx_pcmcia_ops holds necessary function pointers that are filled
> > in the BSP code.
> > 
> 
> argh.
> 
> akpm:/home/akpm> grep '^.*        ' x | wc -l 
> 72
> 
> please, Linux uses hard-tabs, not
> spacespacespacespacespacespacespacespace everywhere.
>

Whoops. That must've survived being copypasted from the original m8xx_pcmcia.c.
That reminds me to do Lindent on the affected sources but that is subject for another patch.
Sorry for the hassle. 

Apparently all the issues were correct, and I'll follow-up with the reworked patch. Thanks for looking at it.

-- 
Sincerely, Vitaly

