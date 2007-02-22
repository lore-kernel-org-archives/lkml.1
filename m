Return-Path: <linux-kernel-owner+w=401wt.eu-S1751510AbXBVIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbXBVIur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXBVIur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:50:47 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:44177 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXBVIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:50:46 -0500
Date: Thu, 22 Feb 2007 09:51:06 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070222085106.GC23916@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <45DA6354.3000305@zytor.com> <20070221120426.GJ4641@enneenne.com> <45DC6FD6.4040005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC6FD6.4040005@zytor.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 08:14:14AM -0800, H. Peter Anvin wrote:
> 
> If you have a kernel driver at all, then it makes perfect sense.  If you 
> don't have a kernel driver at all, then it's irrelevant to the 
> linux-kernel discussion.

???

So you are told me that if my PPS source is connected with a single
CPU GPIO I have to add a new driver to the kernel? I have to choose a
proper major/minor numbers for just one PIN? =:-o

> >RFC simply doesn't consider the fact that you can have a PPS source
> >__without__ a filedes connected with, and a single filedes is
> >considered __always__ connected with a single PPS source.
> 
> That's the Unix way.

But not PPS one. In several embedded systems the GPS antenna is
connected with the serial port and the PPS source, which cames from
the __same__ GPS antenna, is connected with a GPIO.

How I should manage such case? Which fildes I should use? Also
consider that NTPD currently manage only one filedes which should
support both GPS antenna's data and PPS source. My patch can solve
this problem.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
