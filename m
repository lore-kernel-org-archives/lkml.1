Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYISXLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYISXLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYISXKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:10:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYISXKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:10:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=cVrmq6xDQL3HhguK+dB+HvU65laT4vX4tjlWONTGkk8JqII+hMo92B4OJw7UZoeya
	sJjtVCUhkIkH3BayjBIhQ==
Message-ID: <65dd6fd50809191610o566b6747o3813255e0d6a2143@mail.gmail.com>
Date: Fri, 19 Sep 2008 16:10:45 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] fix count(), compat_count() bounds checking
Cc: "Jason Baron" <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <1221865573.8359.2.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919155003.GB3114@redhat.com>
	 <1221865573.8359.2.camel@lappy.programming.kicks-ass.net>
X-GMailtapped-By: 172.25.146.77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 4:06 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Fri, 2008-09-19 at 11:50 -0400, Jason Baron wrote:
> >
> > Simple fix seems to be chaning ++i to i++ and checking for '>='.
>
> Right - looks sane enough, although in practise I'm not sure we'll ever
> care since I suspect we'll hit the target stack limit before this.
>
> Ollie?

Sounds reasonable to me.  I'd also be ok with changing MAX_ARG_STRINGS
to 0x7FFFFFFE to help prevent people from making this mistake in the
future.

Ollie
