Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYASJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYASJEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 04:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbYASJEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 04:04:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:58567 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYASJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 04:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gQNf1+RIlizo3IY+sEB8xxdmtQE6CtEhAE7orNocU9jc0R4oMdqb9EFdUWoJrTxcHPuPIE/FXv90mMgVxp8j+F+N75ZK+wKsU2ED3o+jobhjKvvJUmblq2WQ9al+o3ipjT5373wAYLBbxWzO6k5cFn1BgLJR1mljkOr160KHgYs=
Subject: Re: [PATCH] x86: Unify printk strings in fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080119081331.GB12995@elte.hu>
References: <1200716549.5724.150.camel@brick>
	 <20080119081331.GB12995@elte.hu>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 01:04:24 -0800
Message-Id: <1200733464.5724.166.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-19 at 09:13 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> >  #ifdef CONFIG_X86_32
> > -			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
> > +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
> >  #else
> 
> >  #ifdef CONFIG_X86_32
> > -			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
> > +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
> >  #else
> 
> thanks, applied.
> 
> 	Ingo

I'm just looking at some of the other printks in do+page_fault right
now in the oops code.

What do you prefer:
	"Unable to handle kernel NULL pointer dereference"
or
	"BUG: unable to handle kernel NULL pointer dereference"

Other than that, I think for the most part, the shorter X86_64 strings
are better.

This does change user-visible output however, but would be nice to have
a similar format.

Harvey

