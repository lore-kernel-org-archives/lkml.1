Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbXLOBd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbXLOBd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXLOBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:33:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXLOBdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:33:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Linux 2.6.23.10
Date: Sat, 15 Dec 2007 02:52:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
References: <20071214194952.GA15765@kroah.com> <476326BE.3080002@redhat.com>
In-Reply-To: <476326BE.3080002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712150252.57427.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> >       Freezer: Fix APM emulation breakage
> 
> drivers/char/apm-emulation.c: In function 'apm_ioctl':
> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> make[2]: *** [drivers/char/apm-emulation.o] Error 1
> make[1]: *** [drivers/char] Error 2

This is my fault, sorry.

I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
case.

Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
prepare a separate fix suitable for -stable.

Thanks,
Rafael
