Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbXJYPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbXJYPSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbXJYPRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:17:51 -0400
Received: from gw.goop.org ([64.81.55.164]:55737 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760263AbXJYPRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:17:50 -0400
Message-ID: <4720B383.40701@goop.org>
Date: Thu, 25 Oct 2007 08:17:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Using -traditional in EXTRA_AFLAGS
References: <5d6222a80710242016p27be8bcdk23421efb5990e14a@mail.gmail.com>
In-Reply-To: <5d6222a80710242016p27be8bcdk23421efb5990e14a@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Guys,
>
> is there any particular reason we're using -traditional in
> EXTRA_AFLAGS in Makefiles?
>   

What?  Where?  I thought I removed them all.  Or is this from the x86_64
tree?

> I'd suggest just removing it, but obviously, there might well be
> people with good reasons for it to stay (The same effect of token
> pasting can be achieved in some ways, so if -traditional stays, that's
> not the greatest problem in the world... just that token pasting in
> asm files will diverge from the way in which we (-)traditionally do
> ;-) )
>
> So, does any one have a word on that?
>   


Kill -traditional where ever it may be.  You might need to fix up some
cruft in the process, but shouldn't be too hard.

    J
