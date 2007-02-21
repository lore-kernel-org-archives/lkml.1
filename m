Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbXBUMEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbXBUMEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXBUMEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:04:09 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:57994 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbXBUMEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:04:07 -0500
Date: Wed, 21 Feb 2007 13:04:26 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070221120426.GJ4641@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <45DA6354.3000305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DA6354.3000305@zytor.com>
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

On Mon, Feb 19, 2007 at 06:56:20PM -0800, H. Peter Anvin wrote:

> It's not a precondition for a file descriptor, either.  There are plenty 
> of ioctl-only device drivers in existence.
> 
> Furthermore, a file descriptor doesn't imply a device entry.  Consider 
> pipe(2), for example.
> 
> As far as the kernel is concerned, a file handle is a nice, uniform 
> system for providing communication between the kernel and user space. 
> It doesn't matter if one can read() or write() on it; it's perfectly 
> normal to support only a subset of the normal operations.

The problem is that sometimes you cannot have a filedescriptor at
all. Think about a PPS source connected with a CPU's GPIO pin. You
have no filedes to use and defining one just for a PPS source or for a
class of PPS sources, I think, is a non sense.

RFC simply doesn't consider the fact that you can have a PPS source
__without__ a filedes connected with, and a single filedes is
considered __always__ connected with a single PPS source.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
