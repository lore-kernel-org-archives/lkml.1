Return-Path: <linux-kernel-owner+w=401wt.eu-S937916AbXG0Uuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937916AbXG0Uuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934681AbXG0Uuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:50:35 -0400
Received: from dsl017-112-150.lax1.dsl.speakeasy.net ([69.17.112.150]:41558
	"EHLO NickAndBarb2.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935397AbXG0Uue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:50:34 -0400
X-Greylist: delayed 794 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 16:50:34 EDT
Date: Fri, 27 Jul 2007 13:37:08 -0700
From: Nick Pasich <NewsLetters@NickAndBarb.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>, linux-kernel@vger.kernel.org
Subject: Edgeport UPS Monitoring Problems
Message-ID: <20070727203708.GA10839@NICK2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Greg/Peter/Al,

I've been using the edgeport 4 port USB to Serial Converter 
to monitor APC Smart UPS's via apcupsd for quite awhile on 
various Linux boxes.

I just upgraded to Kernel Version 2.6.22.1 from 2.6.20.6 on a 
couple of systems and both the edgeports stopped communicating.

I tried applying various patches, "PATCH 026/149" and "PATCH 082/149" 
and one by Alan Cox..  but they didn't fix the problem.

I copied the 2.6.20.6 edgeport module sources to the new 
2.6.22.1 tree and everything works again.

          linux/drivers/usb/serial/io_edgeport.c
          linux/drivers/usb/serial/io_edgeport.h
          linux/drivers/usb/serial/io_edgeport.mod.c
          linux/drivers/usb/serial/io_tables.h


I thought you guys ought to be aware of this....

                  Nick Pasich


