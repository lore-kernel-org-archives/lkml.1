Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbXLOB4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbXLOB4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXLOB4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:56:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXLOB4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:56:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Linux 2.6.23.10
Date: Sat, 15 Dec 2007 03:15:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
References: <20071214194952.GA15765@kroah.com> <200712150252.57427.rjw@sisk.pl> <47633028.20503@redhat.com>
In-Reply-To: <47633028.20503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150315.22568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> On 12/14/2007 08:52 PM, Rafael J. Wysocki wrote:
> > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> >> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> >>>       Freezer: Fix APM emulation breakage
> >> drivers/char/apm-emulation.c: In function 'apm_ioctl':
> >> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> >> make[2]: *** [drivers/char/apm-emulation.o] Error 1
> >> make[1]: *** [drivers/char] Error 2
> > 
> > This is my fault, sorry.
> > 
> > I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> > case.
> > 
> > Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> > prepare a separate fix suitable for -stable.
> > 
> 
> It works if you add the changes to freezer.h made in commit
> e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3

Yes, exactly, but a new patch is needed anyway.

Hmm, perhaps it's better to add a new patch on top of "Freezer: Fix APM
emulation breakage"?  Would that be preferred?

Rafael
