Return-Path: <linux-kernel-owner+w=401wt.eu-S1767138AbXDFAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767138AbXDFAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXDFAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:20:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbXDFAUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:20:54 -0400
Message-ID: <46159256.1040705@zytor.com>
Date: Thu, 05 Apr 2007 17:20:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Define EFLAGS_IF
References: <1174533374.2713.104.camel@localhost.localdomain>
In-Reply-To: <1174533374.2713.104.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> There is now more than one place where we use the fact that bit 9 of
> eflags is the interrupt-enabled flag, so define EFLAGS_IF.  We make it
> 512 so it can be used in asm, too.

How about defining all the other EFLAGS in one place?

	-hpa
