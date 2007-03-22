Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXCVDYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXCVDYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965636AbXCVDYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:24:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXCVDYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:24:51 -0400
Subject: Re: [PATCH] Define EFLAGS_IF
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1174533374.2713.104.camel@localhost.localdomain>
References: <1174533374.2713.104.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 14:24:34 +1100
Message-Id: <1174533874.2713.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 14:16 +1100, Rusty Russell wrote:
> There is now more than one place where we use the fact that bit 9 of
> eflags is the interrupt-enabled flag, so define EFLAGS_IF.  We make it
> 512 so it can be used in asm, too.

Belay this: there's a X86_EFLAGS_IF in asm/processor.h which we should
use.  Will send patch.

Thanks to Jeremy Fitzhardinge for the clue.

Rusty.


