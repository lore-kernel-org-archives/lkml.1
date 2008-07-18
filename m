Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYGRRtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYGRRtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYGRRtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:49:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:59049 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYGRRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vug9L+d4jcTo3MQ3dtPiNckNQA7YKtuTKwGTF7PLcTDl6jx9DUk7WV5WpZu1ZcS5Qi
         /sG44hrgF0koPXHhLqVvt6AdaJQ0wFBvQT02V8v3nY0UB+S76IdEv2yEz6K3K+Qh+GXE
         BwmC6z1NIT/s9k6nyItFk/A0sJ0+bvl48NIVU=
Date: Fri, 18 Jul 2008 21:49:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
Message-ID: <20080718174931.GE6897@asus>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus> <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Fri, Jul 18, 2008 at 07:45:53PM +0200]
| On Fri, Jul 18, 2008 at 7:44 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Vegard Nossum - Fri, Jul 18, 2008 at 07:28:21PM +0200]
| > | From e89f2a9f33d01a2df7553b63cb1df525c6e75ad4 Mon Sep 17 00:00:00 2001
| > | From: Vegard Nossum <vegard.nossum@gmail.com>
| > | Date: Fri, 18 Jul 2008 19:14:06 +0200
| > | Subject: [PATCH] x86: warn on apic error
| > |
| > | There are certain APIC errors which are obviously programmer errors,
| > | e.g. writing to illegal APIC registers, or sending invalid interrupt
| > | vectors. Since the error interrupt happens spot on the erroneous code,
| > | we might as well make a bit of noise about it and display the stack-
| > | trace.
| 
| > Hi Vegard, i think you better should use  #APIC_ESR_... macroses
| > from apicdef.h instead of hardcoded bits.
| 
| OOps. I actually had this in my commit message, but it disappeared mysteriously:
| 
|     In particular, the errors we do this for are:
| 
|     - Send CS error
|     - Send accept error
|     - Send illegal vector
|     - Illegal register address
| 
|     (The error codes are listed in a comment just above the code in
|     question.)
| 
| But if these definitions exist, then I will use them. Thanks!
| 
| 
| Vegard
| 
| -- 
| "The animistic metaphor of the bug that maliciously sneaked in while
| the programmer was not looking is intellectually dishonest as it
| disguises that the error is the programmer's own creation."
| 	-- E. W. Dijkstra, EWD1036
| 

iirc, they all were there (though some error codes are specific for
particular processor classes like P4, pentium and other - don't remeber
you could check intel dev manual for this).

		- Cyrill -
