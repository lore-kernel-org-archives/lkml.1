Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXLKQD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXLKQD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXLKQDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:03:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33230 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXLKQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:03:48 -0500
Date: Tue, 11 Dec 2007 08:02:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 3/4] x86: unify asm-x86/page*.h
Message-Id: <20071211080205.309a098b.randy.dunlap@oracle.com>
In-Reply-To: <20071211082627.GA15183@elte.hu>
References: <475DA7CE.6020002@goop.org>
	<20071211082627.GA15183@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 09:26:27 +0100 Ingo Molnar wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Unify common definitions in page*.h.  To simplify other code, I added 
> > typedefs for the value of pte/pmd/pud/pgd values, so they can be used 
> > symbolically elsewhere without needing to have lots of 32/64/PAE 
> > tests.
> 
> thanks, i have picked up the other 4 patches. This one did not apply due 
> to 4 other changes in x86.git#mm:
> 
>  Subject: x86: move page related declaration
>  Subject: x86: make stack size configurable
>  Subject: x86: make sparsemem vmemmap the only memory model
>  Subject: x64/page.h: convert some macros to inlines

If it will help, I'll remake that last one after Jeremy's patches
are applied.

---
~Randy
Features and documentation: http://lwn.net/Articles/260136/
