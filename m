Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXICRim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXICRim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXICRif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:38:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:54689 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXICRie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RrUx6G5cZL0ApI+OMDCSd5U6CH6hfCf7EpMhyp/qPVSB+ICO9yKuSFhIuqQVlebWZQ9gsq5h4ek1fI2wz6bZbeiVAriIQhFluNYsSgRPDwn6YY4hz+kPlU1qfmo/HgeLaYxCzhLoo8zrjbmjKUgPQp591r84txWJlqZJSEP1N14=
Message-ID: <46DC468F.1000300@gmail.com>
Date: Mon, 03 Sep 2007 19:38:23 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz> <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com> <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz> <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com> <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz> <20070830180538.b52b802d.akpm@linux-foundation.org> <46D9C935.3000701@gmail.com> <20070902132847.5fc968b1.akpm@linux-foundation.org> <Pine.LNX.4.64.0709031130000.16753@jikos.suse.cz> <Pine.LNX.4.64.0709031201380.16753@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0709031201380.16753@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jiri Kosina wrote:
> > 

[snip]

> > +/* overriden by architectures supporting brk randomization */
> > +void __weak arch_randomize_brk(struct mm_struct *mm) { }

I was actually suggesting in my last email:

	unsigned long randomize_brk(unsigned long brk)

therefore arch specific code don't have to know about implementation
details ie how to retrieve brk values from a mm. And it also matches
the prototype of arch_align_stack().

		Franck



