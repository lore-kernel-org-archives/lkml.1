Return-Path: <linux-kernel-owner+w=401wt.eu-S1765202AbXE2T65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765202AbXE2T65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764583AbXE2T6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:58:49 -0400
Received: from mtaout1.012.net.il ([84.95.2.1]:53309 "EHLO mtaout1.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764726AbXE2T6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:58:48 -0400
Date: Tue, 29 May 2007 22:58:27 +0300
From: David Baron <d_baron@012.net.il>
Subject: Re: [LAU] 2.6.21-rt7 Oopses, More
X-012-Sender: d_baron@012.net.il
To: linux-kernel@vger.kernel.org
Message-id: <200705292258.27890.d_baron@012.net.il>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 29.05.07 21:37 David Baron <d_baron@012.net.il> wrote:

> >Ran for nearly two hours with none. Nada.
> 
> >Then they started up again. What triggered them?
> 
> >The only thing in the logcheck at the same time as the first outputs
> >was a pptp connect after the original connection fell. Relevant?
> 
> The offending functions are icmp_.... functions, most likely the more
> used ipv4 flavor of icmp.c.
> 
> Example:
> BUG: using smp_processor_id() in preemptible [00000000] code:
> IRQ-9/1110 caller is icmp_xmit_unlock+0xb/0x30
>  [<c01faab9>] debug_smp_processor_id+0xa9/0xb0
>  [<c02e531b>] icmp_xmit_unlock+0xb/0x30
>  [<c02e598e>] icmp_send+0x11e/0x3f0
> ....

Could you please

a) add a Re: to the subject before answering yourself, so this gets a
thread, instead of single mails.

and b) maybe CC linux-kernel@vger.kernel.org as I do not think Ingo
Molnar is subscribed to this list here, but it would be good if he also
gets your reports in order to fix it.

Thanks.

