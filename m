Return-Path: <linux-kernel-owner+w=401wt.eu-S1764095AbXEWJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764095AbXEWJRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXEWJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:17:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbXEWJRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:17:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1
Date: Wed, 23 May 2007 11:22:29 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <20070523004819.2b3ef22d.akpm@linux-foundation.org>
In-Reply-To: <20070523004819.2b3ef22d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231122.30756.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 23 May 2007 09:48, Andrew Morton wrote:
> On Wed, 23 May 2007 00:42:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> 
> This is intermittently getting resume-from-RAM failures.  It is not
> sufficiently repeatable to be able to bisect.
> 
> [ 1381.119362] PM: Preparing system for mem sleep
> [ 2331.798452] Stopping tasks ... 
> [ 2351.760431] Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
> [ 2351.762385]  ksuspend_usbd
> [ 2351.764374]  khubd
> [ 2351.766338] Restarting tasks ... done.

Hmm, that seems to be related to usb-fix-suspend-to-ram.patch (probably one of
the threads is waiting for a completion by some other thread that has been
frozen already).

Greetings,
Rafael
