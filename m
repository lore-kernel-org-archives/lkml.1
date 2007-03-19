Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbXCSUUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbXCSUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXCSUUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:20:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35609 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753165AbXCSUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:20:06 -0400
Date: Mon, 19 Mar 2007 21:20:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][1/5][resend] floppy.c: Initial (partial) CodingStyle cleanup
Message-ID: <20070319202008.GY752@stusta.de>
References: <200703191610.13940.jesper.juhl@gmail.com> <20070319083159.0744cf5e.randy.dunlap@oracle.com> <200703191918.39277.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703191918.39277.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 07:18:38PM +0100, Jesper Juhl wrote:
>...
> The second reason is that indenting two tabs seems to make the most sense for 
> a few reasons;  
> 	a) not indenting at all is ugly, plain and simple.
> 		void function(int a, int b,
> 		int c, int d, int e)
> 		{
> 			int foo;
> 			int bar;
> 		...
> 		}
> 	b) indenting only one tab stop puts parameters at the same indent level as
> 	   variables in the function which is potentially confusing (at least IMHO).
> 		void function(int a, int b,
> 			int c, int d, int e)
> 		{
> 			int foo;
> 			int bar;
> 		...
> 		}
> 	c) Indenting so that all parameter lines start at the opening paranthesis 
> 	   rarely matches up with tabs so you have to use varying amounts of spaces
> 	   depending on how long the function name is. Not a good solution IMHO.
> 		void function(int a, int b,
> 				     int c, int d, int e)
>...

Your example is wrong, it's:

               void function(int a, int b,
                             int c, int d, int e)


This is the most common convention in the kernel - and except for 
extremely long function names it's the one with the best readability.

Yes, it's a problem with extremely long function names, but they are 
rare in the kernel.

And the "varying amounts of spaces" should be handled automatically by 
your editor.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

