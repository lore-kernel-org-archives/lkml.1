Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXFGKM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXFGKM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXFGKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:12:48 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:40652 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXFGKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:12:47 -0400
Date: Thu, 7 Jun 2007 12:14:00 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070607101359.GB15632@enneenne.com>
References: <20070605072501.GA15273@enneenne.com> <20070606132934.18606a17.akpm@linux-foundation.org> <20070606212414.GD6497@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606212414.GD6497@enneenne.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [RFC] PPS: Implementing LinuxPPS API with new syscalls
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:24:16PM +0200, Rodolfo Giometti wrote:
> On Wed, Jun 06, 2007 at 01:29:34PM -0700, Andrew Morton wrote:
> 
> > >    asmlinkage long sys_time_pps_find(int cmd, int __user *source,
> > >                                           char __user *name, int namelen,
> > >                                           char __user *path, int pathlen);
> 
> Try to find a PPS source into the system giving one of its feature.
> 
> With cmd==PPS_FIND_SRC we check for a PPS source with index number
> equal to *source, if *source==-1 we just ask for the first PPS source
> defined into the system.
> 
> With cmd=PPS_FIND_PATH we check for a PPS source with path name equal
> to path.
> 
> Selected source is returned into *source and PPS source info are
> placed into path and name arrays.

Maybe this syscall can be turned into something like:

   asmlinkage long sys_time_pps_ioctl(int cmd, void *ptr);

and data are passed through ptr pointer... obviously first implemented
commands will be PPS_FIND_SRC and PPS_FIND_PATH.

This allows future improvements...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
