Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYICT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYICT44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYICT4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:56:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYICT4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:56:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: thunder7@xs4all.nl
Subject: Re: [Bug #11441] lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
Date: Wed, 3 Sep 2008 22:00:35 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.IxD._hbuIB@albercik> <20080903194417.GA4937@amd64.of.nowhere>
In-Reply-To: <20080903194417.GA4937@amd64.of.nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032200.36471.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of September 2008, thunder7@xs4all.nl wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Date: Sat, Aug 30, 2008 at 09:50:25PM +0200
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11441
> > Subject		: lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
> > Submitter	: jurriaan <thunder7@xs4all.nl>
> > Date		: 2008-08-27 17:05 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121985847724696&w=4
> > Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> > 		  Neil Brown <neilb@suse.de>
> > Patch		: http://marc.info/?l=linux-kernel&m=121998896602338&w=4
> > 
> As a matter of fact, now it's even worse.
> 
> On bootup, I see
> 
> md4: bitmap initalized from disk: read 10/10 pages, set 6 bits
> created bitmap for device md4 (156 pages)
> unable to handle null pointer dereference
> write_page+0x179
> 
> _spin_unlock_irqrestore
> bitmap_update_sb
> bitmap_create
> do_md_run
> [ snipped the rest ]
> 
> when I boot 2.6.27-rc5 with the mentioned patch. I've written this
> information down by hand. I don't have a dmesg, since my root filesystem
> is on a raid1-volume, and thus I can't boot 2.6.27-rc5.
> If you need more information, please let me know.

Can you test the current -git kernel, please?

Rafael
