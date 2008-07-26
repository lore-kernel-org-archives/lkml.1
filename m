Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYGZS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYGZS2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYGZS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:28:07 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:52640 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYGZS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=B6mk7lPq6oa9Hg1Ub8/fAU/NTIgKUjETPTI+1dSOwfQrjLIbBtVlC7LBtVEw0yR51d
         A2gVVRpg/r3q0NYtRrUaXJIuiPakEkTn8LvX+oB2MG6iQ0OI+wF9lJH3DUJ3sygfr9VP
         bCGflyxaf1Sim/gwMAp18u283xotg24K7sFqQ=
Message-ID: <19f34abd0807261128k185110faxedd2a1d2a6078bfc@mail.gmail.com>
Date: Sat, 26 Jul 2008 20:28:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -next] kmemcheck: include module.h to prevent warnings
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, vegardno@ifi.uio.no,
       penberg@cs.helsinki.fi, akpm <akpm@linux-foundation.org>
In-Reply-To: <20080726154346.GB15945@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080724160932.cdcf4927.randy.dunlap@oracle.com>
	 <20080726154346.GB15945@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 5:43 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> kmemcheck/shadow.c needs to include <linux/module.h> to prevent
>> the following warnings:
>>
>> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : data definition has no type or storage class
>> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
>> linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : parameter names (without types) in function declaration
>
> applied to tip/kmemcheck - thanks Randy.

I am obviously also grateful for this patch. Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
