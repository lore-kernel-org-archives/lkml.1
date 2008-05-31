Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYEaPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYEaPUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYEaPUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:20:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYEaPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:20:24 -0400
Message-ID: <48416A56.5010904@zytor.com>
Date: Sat, 31 May 2008 08:10:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	<20080528.225826.40264516.davem@davemloft.net>	<1212041839.8888.38.camel@pasglop>	<20080529124548.GC8065@mit.edu>	<1212077700.26088.83.camel@shinybook.infradead.org>	<483F002E.5060002@garzik.org>	<1212095864.24826.2.camel@lappy.programming.kicks-ass.net>	<483F3EC4.5050700@zytor.com>	<20080530103107.4f71cfe3@core>	<48408A67.4090006@zytor.com> <20080531150526.46cda105@core>
In-Reply-To: <20080531150526.46cda105@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> (*) Not saying that a klibc-based initramfs is necessarily smaller than 
>> the in-kernel code it replaces, but the total size is << than the size 
>> of the kernel proper, which isn't true when using a full-featured libc.
> 
> True but with a vendor hat on thats not usually a problem on modern
> systems and using glibc means less code to maintain, less special cases,
> and more flexibility.
> 
> For embedded klibc may well be interesting.

For vendor hat meaning full-blown systems, yes that is true, but for 
embedded, or even on some "real" platforms, that definitely matters.

Fundamentally, however, we're never going to have a full-blown libc 
environment built out of the kernel tree, as its size would be 
comparable or larger than the kernel itself.

	-hpa
