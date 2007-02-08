Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXBHXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXBHXUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965717AbXBHXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:20:54 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:35139 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXBHXUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:20:54 -0500
Date: Fri, 9 Feb 2007 00:20:49 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <Pine.LNX.4.64.0702081500190.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702090014020.14457@scrub.home>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
 <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702082335150.14457@scrub.home>
 <Pine.LNX.4.64.0702081500190.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> On Thu, 8 Feb 2007, Roman Zippel wrote:
> 
> > I don't quite understand, the Makefile doesn't care anymore about /bin/sh 
> > with this patch, the Makefile checks only for $BASH and /bin/bash 
> 
> Exactly. 
> 
> The point is, neither $BASH nor /bin/bash may be set.

Is that really a problem? I think any system that has bash without 
/bin/bash is simply broken.

> If you run make while running tcsh, "BASH" won't be set. We've always just 
> defaulted to doing /bin/sh. Doesn't really seem to be a problem.

There are chances this is already broken anyway. We call external scripts 
using $(shell $(CONFIG_SHELL) ...), which ignores the "#! ..." setting.

bye, Roman
