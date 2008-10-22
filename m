Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYJVPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYJVPlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYJVPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:41:11 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:50598 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYJVPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:41:10 -0400
Date: Wed, 22 Oct 2008 16:41:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Glauber Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
In-Reply-To: <20081022141354.GA26372@elte.hu>
Message-ID: <alpine.LFD.1.10.0810221630390.24509@ftp.linux-mips.org>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Ingo Molnar wrote:

> i'm wondering - is the server there really that old, that it has no 
> integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some 
> other, weird SMP box?

 I've been wondering about that too, though the fix is correct either way.  

 Note that all the discrete APIC boxes we have ever supported were 
Pentium-based, either the original P5 (i.e. 60/66MHz) chips which had no 
APIC on chip at all or P54C ones but with the integrated APIC disabled 
(because the systems were 4-way SMP or suchlike and there was no suitable 
chipset component to provide a compatible I/O APIC).

 All the documentation for i486 SMP boxes I was able to track down 
indicated that even if APIC chips were used with them, the whole setup did 
not support the MP table as defined by the MultiProcessor Specification 
and therefore could not be supported by Linux as it is.  And I have never 
come across a specimen to look into it any further.

  Maciej
