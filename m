Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbXLODc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbXLODc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 22:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXLODcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 22:32:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:46063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbXLODcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 22:32:19 -0500
Date: Fri, 14 Dec 2007 19:35:18 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.10
Message-ID: <20071215033518.GA31056@suse.de>
References: <20071214194952.GA15765@kroah.com> <476326BE.3080002@redhat.com> <200712150252.57427.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712150252.57427.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:52:56AM +0100, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> > >       Freezer: Fix APM emulation breakage
> > 
> > drivers/char/apm-emulation.c: In function 'apm_ioctl':
> > drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> > make[2]: *** [drivers/char/apm-emulation.o] Error 1
> > make[1]: *** [drivers/char] Error 2
> 
> This is my fault, sorry.
> 
> I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> case.
> 
> Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> prepare a separate fix suitable for -stable.

Thanks, I'll revert this and do a new release.  If you want to send
another patch to fix this so it builds, I'll add it to the queue for the
next release.

greg k-h
