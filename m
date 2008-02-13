Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYBMIVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYBMIVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYBMIVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:21:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYBMIVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:21:17 -0500
Date: Wed, 13 Feb 2008 00:25:37 -0800
From: Greg KH <greg@kroah.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Scott Lovenberg <scott.lovenberg@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Documentation about sysfs/procfs entries
Message-ID: <20080213082537.GA14098@kroah.com>
References: <804dabb00802112123t774623b2n3e1e0a4addde1512@mail.gmail.com> <b1fc6a560802112217j57ab3fa1h611864a6a2423943@mail.gmail.com> <804dabb00802112346q240745abm93b6257f2cd64e60@mail.gmail.com> <47B15DD2.3090706@gmail.com> <f284c33d0802121808v2e41b648u83070ac1f6f1bb2a@mail.gmail.com> <20080212204348.4a858650.randy.dunlap@oracle.com> <47B2874F.5000805@gmail.com> <20080213073159.GA13414@kroah.com> <804dabb00802122340t555e3c26ma903ef97991dd13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802122340t555e3c26ma903ef97991dd13@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:40:32PM +0800, Peter Teoh wrote:
> some questions:
> 
> a.   the list of parameters can presumably be extracted from existing
> file via "procname" search.....not sure if it is correct (as per
> attached, complete?)

I don't see anything attached :(

> b.   what is the diff between /proc and /sys?   in
> Documentation/filesystems/proc.txt....it is mentioned that /proc
> information will be published into a book...where is it?   I can never
> understand this.

/proc is for process information originally, it grew to take lots of
other different things over the years.

/sys is a tree representation of the devices in the system, as well as a
location for a lot of other kernel specific information.  The rules for
/sys are much more strict (one value per file, if the file isn't there,
the userspace program must be able to handle it, etc.)

> c.   in Doc/sysctl are all the explanation for /proc/sys/* .... as a
> start i think we shall contribute fixing here....but according to your
> email, we should fix Doc/ABI...so I supposed some migration is needed?

Yes, migration of this information to the ABI/ directory would be very
good to have.

> d.   In networking/ip-sysctl.txt a lot of the explanation for the
> attached procname's parameters are explained, may be we can relocate
> it to ABI?

Sounds good to me, but be sure to verify this with the networking
developers as well.

thanks,

greg k-h
