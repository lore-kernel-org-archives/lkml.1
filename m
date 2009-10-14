Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbZJNOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbZJNOyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934251AbZJNOyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:54:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934040AbZJNOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:54:20 -0400
Date: Wed, 14 Oct 2009 07:53:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michael Ellerman <michael@ellerman.id.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Boyan <btanastasov@yahoo.co.uk>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, fredlwm@gmail.com,
       Ed Tomlinson <edt@aei.ca>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Characters vanishing in the tty layer? (maybe related to [Bug
 #14388] keyboard under X with 2.6.31)
In-Reply-To: <1255501294.21962.24.camel@concordia>
Message-ID: <alpine.LFD.2.01.0910140748420.6146@localhost.localdomain>
References: <1255501294.21962.24.camel@concordia>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Michael Ellerman wrote:
> 
> I'm using 80f5069 or thereabouts, plus some powerpc patches. We also see
> the bug in 31, but not in 27.

Could you bisect it? Even if you don't bisect it _all_ the way, 27..31 is 
a big range. Doing just a handful of bisections (say six or seven) would 
cut down the number of commits from 47 thousand to somewhat more 
manageable "hundreds of commits"... But obviously going all the way would 
be better.

		Linus
