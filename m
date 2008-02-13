Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbYBMRex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbYBMRex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbYBMReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:34:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:32648 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764870AbYBMReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oHXrF+vnAF5tWSKSxIt0X6jip4dszTtnvgRGkpO2RRnF/cT0125ugwsV+LTA/QFRVZ7iD//dQcN7P/eoJ0jfQHbYF61geEnIXaSaWCS2hN8LehvMDtxq6y635Kkkum24iJ+hoYlmqfCCjef84Nucs9BvuEz7j44SqClQMoWTiA4=
Subject: Re: [PATCH] x86: include prototype for no_broadcast in
	mach-default/setup.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080213104227.GC32241@elte.hu>
References: <1202848517.28953.11.camel@brick>
	 <20080213104227.GC32241@elte.hu>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 09:34:06 -0800
Message-Id: <1202924047.9824.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 11:42 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Fixes sparse warning:
> > arch/x86/mach-default/setup.c:19:5: warning: symbol 'no_broadcast' was not declared. Should it be static?
> 
> hm, this patch causes a build failure:
> 
> In file included from arch/x86/mach-default/setup.c:13:
> include/asm/mach-default/mach_ipi.h: In function '__local_send_IPI_allbutself':
> include/asm/mach-default/mach_ipi.h:25: error: 'APIC_DEST_ALLBUT' undeclared (first use in this function)
> include/asm/mach-default/mach_ipi.h:25: error: (Each undeclared identifier is reported only once
> include/asm/mach-default/mach_ipi.h:25: error: for each function it appears in.)include/asm/mach-default/mach_ipi.h: In function '__local_send_IPI_all':
> include/asm/mach-default/mach_ipi.h:33: error: 'APIC_DEST_ALLINC' undeclared (first use in this function)
> 
> config attached. The include file dependencies in this area are a bit of 
> a mess - perhaps they need some cleanups?

OK, I'm building all(yes|mod)configs and didn't see this.  Agreed about
the file dependencies here, I'll take a look.  If you have any notes
lying around, would appreciate the head-start.


Harvey


