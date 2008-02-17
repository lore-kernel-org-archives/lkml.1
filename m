Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYBQVg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYBQVg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYBQVgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:36:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:62654 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYBQVgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IFccI7g+DgDFe/dyTWRd8n35KAWMqUIgsYOlYlZS6lHlCFAzWvhyHmR5A+sntti1mO0FrQTpRnjF0dAP8UDxl9TkYb7BnwB1yFS+iPtWl4Vx+gLz4Ms/m5nkwhjlu0lFjuvNS9DtXF/GbJ/YkpbOz4pCX0fpvdJWEzLk8YMWJxw=
Subject: Re: [PATCH] x86: include prototype for no_broadcast in
	mach-default/setup.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080217200950.GA31865@elte.hu>
References: <1202848517.28953.11.camel@brick>
	 <20080213104227.GC32241@elte.hu> <1202924047.9824.14.camel@brick>
	 <20080217200950.GA31865@elte.hu>
Content-Type: text/plain
Date: Sun, 17 Feb 2008 13:36:52 -0800
Message-Id: <1203284212.5757.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-17 at 21:09 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > > config attached. The include file dependencies in this area are a 
> > > bit of a mess - perhaps they need some cleanups?
> > 
> > OK, I'm building all(yes|mod)configs and didn't see this.  Agreed 
> > about the file dependencies here, I'll take a look.  If you have any 
> > notes lying around, would appreciate the head-start.
> 
> make randconfig build failure:
> 
> include/asm/mach-default/mach_ipi.h: In function 
> '__local_send_IPI_allbutself':
> include/asm/mach-default/mach_ipi.h:25: error: 'APIC_DEST_ALLBUT' 
> undeclared (first use in this function)
> include/asm/mach-default/mach_ipi.h:25: error: (Each undeclared 
> identifier is re
> 
> config attached below.
> 

Just drop the patch, I'm looking into the mach-* include mess, will
hopefully have some stuff next week.

Harvey

