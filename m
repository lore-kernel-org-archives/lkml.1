Return-Path: <linux-kernel-owner+w=401wt.eu-S938162AbXG0WY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938162AbXG0WY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934206AbXG0WYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:24:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933423AbXG0WYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:24:18 -0400
Date: Fri, 27 Jul 2007 15:22:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Pasich <NewsLetters@NickAndBarb.net>,
       linux-usb-devel@lists.sourceforge.net
Cc: Greg Kroah-Hartman <greg@kroah.com>, Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>, linux-kernel@vger.kernel.org
Subject: Re: Edgeport UPS Monitoring Problems
Message-Id: <20070727152254.202959c1.akpm@linux-foundation.org>
In-Reply-To: <20070727203708.GA10839@NICK2>
References: <20070727203708.GA10839@NICK2>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 13:37:08 -0700
Nick Pasich <NewsLetters@NickAndBarb.net> wrote:

> 
> Greg/Peter/Al,

added linux-usb-devel.

> I've been using the edgeport 4 port USB to Serial Converter 
> to monitor APC Smart UPS's via apcupsd for quite awhile on 
> various Linux boxes.
> 
> I just upgraded to Kernel Version 2.6.22.1 from 2.6.20.6 on a 
> couple of systems and both the edgeports stopped communicating.
> 
> I tried applying various patches, "PATCH 026/149" and "PATCH 082/149" 
> and one by Alan Cox..  but they didn't fix the problem.
> 
> I copied the 2.6.20.6 edgeport module sources to the new 
> 2.6.22.1 tree and everything works again.
> 
>           linux/drivers/usb/serial/io_edgeport.c
>           linux/drivers/usb/serial/io_edgeport.h
>           linux/drivers/usb/serial/io_edgeport.mod.c
>           linux/drivers/usb/serial/io_tables.h
> 
> 
> I thought you guys ought to be aware of this....
> 

Straightforward regression, most serious.  Thanks for reporting it.
