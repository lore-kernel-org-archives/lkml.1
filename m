Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbXGKHHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbXGKHHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXGKHG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:06:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbXGKHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:06:56 -0400
Date: Wed, 11 Jul 2007 00:05:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefano Rivoir <s.rivoir@gts.it>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <46947ADF.4080605@gts.it>
Message-ID: <alpine.LFD.0.999.0707110002460.3412@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
 <46947ADF.4080605@gts.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Stefano Rivoir wrote:
> 
> Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x (which
> is installed on my debian/sid) turns into a hang (in init, seemingly, maybe
> not even in kernel itself), while gcc-4.1 is allright.
> 
> Probably it's something I had to know before... but the light lit when gcc
> crashed when compiling 2.6.22-git1...

Ok, I guess I should be happy, but gcc bugs end up being an absolute 
*horror* to try to debug, and there is always a slight possibility that it 
isn't a gcc bug, but some real kernel bug that is just hidden by the old 
code generation. It happens occasionally.

The fact that gcc itself crashed when trying to compile something does 
seem to indicate that it's one of those cases where it's unquestionably an 
outright gcc bug, and we don't have to worry about some dodgy kernel code. 
Which is a bit of a relief, but still, the gcc bug needs to be found, 
preferably before that thing actually gets released.

I'm hoping your Debian/sid gcc version is some very experimental 
known-buggy one, and not something that people _expect_ to be solid and 
work well?

		Linus
