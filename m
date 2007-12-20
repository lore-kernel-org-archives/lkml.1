Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXLTTpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXLTTpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXLTTpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:45:18 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64669 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbXLTTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:45:16 -0500
Date: Thu, 20 Dec 2007 11:54:50 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: not needed patch
In-reply-to: <20071220142906.GA20794@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>
Message-id: <200712201154.50500.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200712192057.02500.yinghai.lu@sun.com>
 <20071220142906.GA20794@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 06:29:06 am Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > Ingo.
> > 
> > commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9 is not needed. another 
> > patch (by you !! commit 699d934d5f958d7944d195c03c334f28cc0b3669 x86: 
> > fixup cpu_info array conversion) already removed clearing of 
> > c->cpu_index. in identify_cpu
> > also it is not consisent to smpboot_32.c. (it will assign id to 
> > cpu_index right after
> >
> >  	*c = boot_cpu_data;
> > )
> 
> well, it might in the worst-case be a superfluous change, but not cause 
> any problems in 2.6.24, right?

now it is ok with 2.6.24.

> 
> > by revert commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, we could 
> > use c->cpu_index in identify_cpu.
> 
> but that's 2.6.25 stuff, right? Travis?
or at least before bewfore merging smpboot_32.c and smpboot_64.c

YH
