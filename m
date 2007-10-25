Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXJYPWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXJYPWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbXJYPWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:22:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:42841 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192AbXJYPV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TdE5KkT7if/+/ewPq2za7WfKClBRRbm+qETbSbx10pvvSytWbmYc9jB+m2SQP4zg1/Y2PtDbHS7gcax7niHbuRZmxuXy55l3viQNb9myzTp+LOht3iPdEDhhKbVT0n43BBj66Qivie0TkIu7KBWwnWx9jB+BQ88HyLS3hjwkQoQ=
Message-ID: <5d6222a80710250821x1da3fef1gabf4b776a7b33048@mail.gmail.com>
Date: Thu, 25 Oct 2007 13:21:50 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Using -traditional in EXTRA_AFLAGS
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4720B383.40701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d6222a80710242016p27be8bcdk23421efb5990e14a@mail.gmail.com>
	 <4720B383.40701@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Glauber de Oliveira Costa wrote:
> > Guys,
> >
> > is there any particular reason we're using -traditional in
> > EXTRA_AFLAGS in Makefiles?
> >
>
> What?  Where?  I thought I removed them all.  Or is this from the x86_64
> tree?

This is from arch/x86/kernel/Makefile_64

> > I'd suggest just removing it, but obviously, there might well be
> > people with good reasons for it to stay (The same effect of token
> > pasting can be achieved in some ways, so if -traditional stays, that's
> > not the greatest problem in the world... just that token pasting in
> > asm files will diverge from the way in which we (-)traditionally do
> > ;-) )
> >
> > So, does any one have a word on that?
> >
>
>
> Kill -traditional where ever it may be.  You might need to fix up some
> cruft in the process, but shouldn't be too hard.
>
I only feel confortable about killing it from x86_64 or any other
arches I may have access to. Otherwise, there's no way I can fix up
the crufts ;)

A patch for Makefile_64 will follow in a while.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
