Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbXBHXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbXBHXCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbXBHXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:02:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbXBHXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:02:39 -0500
Date: Thu, 8 Feb 2007 15:02:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Oleg Verych <olecom@flower.upol.cz>
Subject: Re: The who needs reviews anyways [PATCH]
In-Reply-To: <Pine.LNX.4.64.0702082335150.14457@scrub.home>
Message-ID: <Pine.LNX.4.64.0702081500190.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702082227020.14457@scrub.home>
 <Pine.LNX.4.64.0702081414150.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702082335150.14457@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Roman Zippel wrote:

> I don't quite understand, the Makefile doesn't care anymore about /bin/sh 
> with this patch, the Makefile checks only for $BASH and /bin/bash 

Exactly. 

The point is, neither $BASH nor /bin/bash may be set.

If you run make while running tcsh, "BASH" won't be set. We've always just 
defaulted to doing /bin/sh. Doesn't really seem to be a problem.

		Linus
