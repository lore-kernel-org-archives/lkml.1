Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYIEQPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYIEQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYIEQPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:15:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39706 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYIEQPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:15:30 -0400
Message-Id: <48C17754.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 17:15:48 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux@sandersweb.net>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi-suse@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net>
 <20080831122751.72afafb5@infradead.org>
 <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org>
 <200809051138.20615.linux@sandersweb.net>
In-Reply-To: <200809051138.20615.linux@sandersweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>--- a/include/asm-x86/nops.h
>+++ b/include/asm-x86/nops.h
>@@ -84,7 +84,7 @@
> #define ASM_NOP6 K7_NOP6
> #define ASM_NOP7 K7_NOP7
> #define ASM_NOP8 K7_NOP8
>-#elif defined(CONFIG_X86_P6_NOP)
>+/* #elif defined(CONFIG_X86_P6_NOP)
> #define ASM_NOP1 P6_NOP1
> #define ASM_NOP2 P6_NOP2
> #define ASM_NOP3 P6_NOP3
>@@ -93,6 +93,7 @@
> #define ASM_NOP6 P6_NOP6
> #define ASM_NOP7 P6_NOP7
> #define ASM_NOP8 P6_NOP8
>+*/
> #elif defined(CONFIG_X86_64)
> #define ASM_NOP1 K8_NOP1
> #define ASM_NOP2 K8_NOP2

I disagree here: If I configure a 686+ kernel, I expect these NOPs to be
that way (and to work). If you want to run on something that's not
compliant, you just shouldn't configure your kernel that way.

Jan

