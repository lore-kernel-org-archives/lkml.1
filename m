Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbYCaKSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbYCaKSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYCaKSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:18:11 -0400
Received: from www.tglx.de ([62.245.132.106]:52774 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYCaKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:18:11 -0400
Date: Mon, 31 Mar 2008 12:17:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Michlmayr <tbm@cyrius.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
In-Reply-To: <20080331095729.GI28821@deprecation.cyrius.com>
Message-ID: <alpine.LFD.1.10.0803311213020.3219@apollo.tec.linutronix.de>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
 <20080331095729.GI28821@deprecation.cyrius.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Martin Michlmayr wrote:

> * Thomas Gleixner <tglx@linutronix.de> [2008-03-30 22:10]:
> > Can we please have a full boot log (dmesg) and the output of /proc/interrupts and "lspci -vvv"
> 
> I've attached all of that information.

Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config ? If
yes, can you please disable it and check whether the problem persists ?

Thanks,
	tglx
