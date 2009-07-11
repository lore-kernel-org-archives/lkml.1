Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZGKPs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZGKPs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZGKPsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:48:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:43466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZGKPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:48:46 -0400
Date: Sat, 11 Jul 2009 08:49:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Siarhei Liakh <sliakh.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090711084958.69ff9196@infradead.org>
In-Reply-To: <200907111821.47769.rusty@rustcorp.com.au>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com>
	<20090710112403.GC3760@elte.hu>
	<200907111537.03191.rusty@rustcorp.com.au>
	<200907111821.47769.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 18:21:46 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sat, 11 Jul 2009 03:37:01 pm Rusty Russell wrote:
> > On Fri, 10 Jul 2009 08:54:03 pm Ingo Molnar wrote:
> > > please use the customary comment style:
> >
> > Please don't.  There's one spot in that file which does it, and
> > frankly it's a distracting waste of space.
> 
> Sorry, Ingo there's more than one.  I don't bother fixing up others'
> comments in patches, so the file is now a bit mixed.  It'd be better
> to make it uniform, in which case I'd change it to kernel-style.
> 
> I have a question about this patch though: I think it's unsafe in
> general to mark the last partial page as NX (we asked for executable
> pages, this could remove executable from some unrelated allocation).
> 

we vmalloc / g_f_p modules right? so we don't share the last page.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
