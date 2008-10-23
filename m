Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYJWHka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYJWHka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYJWHkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:40:19 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57552 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYJWHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:40:18 -0400
Date: Thu, 23 Oct 2008 09:39:57 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20081023073957.GU4390@tekkaman>
References: <1224683240-15439-1-git-send-email-giometti@linux.it> <1224683240-15439-2-git-send-email-giometti@linux.it> <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org> <20081022204800.GT4390@tekkaman> <20081022135810.37c564f8.akpm@linux-foundation.org> <20081022210352.GA29754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022210352.GA29754@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/2] Add c2 port support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:03:52PM -0700, Greg KH wrote:

> > Why is that good?  We have hundreds and hundreds of drivers which use a
> > device node interface and they work OK.
> > 
> > sysfs was never intended for use as the sole interface between device
> > drivers and userspace.  Using it that way is somewhat unconventional. 
> > At the very least I do think it needs more justification and
> > explanation than we're being provded here.
> 
> For firmware download to devices, using sysfs is the "normal" interface
> these days, that is what the firmware class is for.
> 
> Which reminds me, Rodolfo, why didn't you just use that interface for
> your firmware downloading instead of rolling your own here?

Because I need also to know revision ID, device ID and other minor
info from the microcontroller. Also I can reset the microcontroller
when I need it without downloading any new firmware.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
