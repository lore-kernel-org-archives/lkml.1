Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXDFAWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXDFAWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbXDFAWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:22:42 -0400
Received: from gw.goop.org ([64.81.55.164]:44318 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbXDFAWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:22:41 -0400
Message-ID: <461592AA.4060103@goop.org>
Date: Thu, 05 Apr 2007 17:22:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Define EFLAGS_IF
References: <1174533374.2713.104.camel@localhost.localdomain> <46159256.1040705@zytor.com>
In-Reply-To: <46159256.1040705@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rusty Russell wrote:
>   
>> There is now more than one place where we use the fact that bit 9 of
>> eflags is the interrupt-enabled flag, so define EFLAGS_IF.  We make it
>> 512 so it can be used in asm, too.
>>     
>
> How about defining all the other EFLAGS in one place?
>   

That patch got dropped, and replaced by one which pulled all the flags
definitions out of <asm/processor.h>

    J
