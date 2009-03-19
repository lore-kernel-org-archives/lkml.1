Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZCSWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZCSWxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZCSWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:53:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761541AbZCSWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:53:16 -0400
Date: Thu, 19 Mar 2009 15:50:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       git-commits-head@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Add '-fwrapv' to gcc CFLAGS
In-Reply-To: <20090319222848.GA26278@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0903191550100.3030@localhost.localdomain>
References: <200903192159.n2JLx1Bu020711@hera.kernel.org> <20090319222848.GA26278@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Mar 2009, Sam Ravnborg wrote:
> 
> Path is buggy.
> We have several architectures that plays strange games with $(CC)
> and $(CROSS_COMPILE).

Argh. It looked obvious, and worked for me, but..

> So we need to postpone any use of $(call cc-option..)
> until we have included the arch specific Makefile so
> we try with the correct $(CC) version.
> 
> If you move it below the include at around line 530 you
> should be safe.

Will do.

		Linus
