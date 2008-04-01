Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYDAJAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYDAJAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYDAI75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:59:57 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:48957 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbYDAI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:59:56 -0400
Date: Tue, 1 Apr 2008 10:59:50 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20080401085950.GZ7279@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <20080328032139.7af69ff9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328032139.7af69ff9.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 03:21:39AM -0700, Andrew Morton wrote:
> On Thu,  6 Mar 2008 13:09:00 +0100 Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > This patch adds the kernel side of the PPS support currently named
> > "LinuxPPS".
> 
> powerpc:
> 
> drivers/pps/pps.c: In function 'pps_cdev_ioctl':
> drivers/pps/pps.c:166: warning: format '%lld' expects type 'long long int', but argument 2 has type '__s64'
> drivers/pps/kapi.c: In function 'pps_event':
> drivers/pps/kapi.c:225: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__s64'
> drivers/pps/sysfs.c: In function 'pps_show_assert':
> drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> drivers/pps/sysfs.c: In function 'pps_show_clear':
> drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'

Oops! I have no powerpc system... how can I solve this issue? Using
type __s64 is not compiling safe? =:-o

Googling on the net I found:

#include <inttypes.h>

 int64_t var;
 sprintf (buf, "%" PRId64, var);

but this is not implemented into the kernel... maybe I can add it into
my driver or should I propose a patch for the kernel?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
