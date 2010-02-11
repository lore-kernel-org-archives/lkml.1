Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0BKXjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:39:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab0BKXjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:39:00 -0500
Date: Thu, 11 Feb 2010 15:38:12 -0800
From: Greg KH <gregkh@suse.de>
To: Bastian Blank <waldi@debian.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stefan Haberland <stefan.haberland@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [11/74] [S390] dasd: fix possible NULL pointer errors
Message-ID: <20100211233812.GC10315@suse.de>
References: <20100204171850.GA16539@kroah.com>
 <20100204171452.915396715@linux.site>
 <20100211231547.GA20925@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211231547.GA20925@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:15:47AM +0100, Bastian Blank wrote:
> On Thu, Feb 04, 2010 at 09:11:42AM -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Hmm, are such patches not sent to the arch list, linux-s390 in this
> case?

I copy the people on the original patch, and the linux-kernel list.  To
dig out all of the different subsystem mailing lists would be a solution
for a way to use the get_maintainer.pl script in some automated fashion
that I have not figured out.

Patches to quilt or git-format-email to do this are gladly accepted :)

> Anyway, it breaks without b8ed5dd54895647c2690575aad6f07748c2c618a:
> | drivers/s390/block/dasd.c: In function 'dasd_handle_killed_request':
> | drivers/s390/block/dasd.c:1008: error: implicit declaration of function 'DBF_EVENT_DEVID'

Yeah, I saw that after the fact.  I'll queue this up for the next
-stable release, thanks, I hadn't dug into what the real solution for
this was.

thanks,

greg k-h
