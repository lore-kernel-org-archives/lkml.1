Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZD0XfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZD0XfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZD0XfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:35:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53096 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbZD0XfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:35:05 -0400
Date: Tue, 28 Apr 2009 00:34:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akataria@vmware.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Default HZ value for X86
Message-ID: <20090428003454.08d1660c@lxorguk.ukuu.org.uk>
In-Reply-To: <1240873630.14713.25.camel@alok-dev1>
References: <1240873630.14713.25.camel@alok-dev1>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 16:07:10 -0700
Alok Kataria <akataria@vmware.com> wrote:

> Hi, 
> 
> I was wondering why do we still have the default HZ value as 1000 for
> the x86 kernels.
> 
> arch/x86/configs/i386_defconfig:CONFIG_HZ=1000
> arch/x86/configs/x86_64_defconfig:CONFIG_HZ=1000
> 
> With the highres timer implementation it was planned to move away from
> relying on high timer interrupt frequency for applications requiring
> precise high resolution timers.

With the tickless kernel does this really matter any more ? We might as
well keep a logical 1000 for convenience and accuracy.

Alan
