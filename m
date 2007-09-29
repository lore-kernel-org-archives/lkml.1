Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbXI2Sag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbXI2Sag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXI2Sa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:30:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64975 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXI2Sa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:30:28 -0400
Date: Sat, 29 Sep 2007 11:29:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Message-Id: <20070929112928.56a04641.randy.dunlap@oracle.com>
In-Reply-To: <20070929035156.cd6fe860.akpm@linux-foundation.org>
References: <20070929122530.5c45f743@hyperion.delvare>
	<20070929035156.cd6fe860.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 03:51:56 -0700 Andrew Morton wrote:

> On Sat, 29 Sep 2007 12:25:30 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Remove a not particularly relevant rule from CodingStyle.
> > Sometimes, printing numbers in parentheses doesn't add value, but in
> > some (most?) cases it makes the message easier to read. As a matter of
> > fact, this practice is widely used in the kernel:
> > 
> > linux-2.6.23-rc8$ quilt grep -I '(%l*[du])' | wc -l
> > 3166
> > linux-2.6.23-rc8$
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  Documentation/CodingStyle |    2 --
> >  1 file changed, 2 deletions(-)
> > 
> > --- linux-2.6.23-rc8.orig/Documentation/CodingStyle	2007-07-23 16:44:32.000000000 +0200
> > +++ linux-2.6.23-rc8/Documentation/CodingStyle	2007-09-28 23:53:23.000000000 +0200
> > @@ -638,8 +638,6 @@ concise, clear, and unambiguous.
> >  
> >  Kernel messages do not have to be terminated with a period.
> >  
> > -Printing numbers in parentheses (%d) adds no value and should be avoided.
> > -
> >  There are a number of driver model diagnostic macros in <linux/device.h>
> >  which you should use to make sure messages are matched to the right device
> >  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> 
> I wonder how that got there.

http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=4034429a6JsOCMNXT3tTPAX1kX40bg

Let's kill it, please.  (i.e., ACK)

---
~Randy
