Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbXBKWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbXBKWl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932604AbXBKWlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:41:25 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:43343 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbXBKWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:41:24 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200702110127.35631.rjw@sisk.pl>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171147026.19894.16.camel@nigel.suspend2.net> <45CE5934.3020801@imap.cc>
	 <200702110127.35631.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 09:41:23 +1100
Message-Id: <1171233683.4493.81.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-11 at 01:27 +0100, Rafael J. Wysocki wrote:
> On Sunday, 11 February 2007 00:45, Tilman Schmidt wrote:
> > Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> > > If your device requires power management, and you know it requires power
> > > management, why not just implement power management? Doing -ENOSYS
> > > instead is like saying -ESPAMMEBECAUSEIMLAZY.
> > 
> > Like it or not, power management is far from trivial, and people
> > writing device drivers have limited resources. Calling them lazy
> > does not help that in the least. If you try to put pressure on them
> > by refusing to merge their work as long as it doesn't provide this
> > or that functionality, you *may* end up with a few drivers having
> > that functionality which otherwise wouldn't, but you *will* also
> > end up with a number of drivers never making it into the kernel
> > because their authors just have to give up.
> > 
> > Also, in your argument you neglected a few cases:
> > - What if my device does not require power management?
> > - What if I don't know whether my device requires power management?
> > - What if I know my device would require power management, but don't
> >   know how to implement it?
> 
> Plus:
> - What if I'm planning to implement the power managemet, but not just right
> now?

Why not right now?
 
Regards,

Nigel

