Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbXCTLaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbXCTLaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXCTLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:30:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:41818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbXCTLaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:30:09 -0400
Message-ID: <6376056.1174390189360.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
Date: Tue, 20 Mar 2007 12:29:49 +0100 (CET)
From: Andreas Kleen <ak@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Cc: jesper.juhl@gmail.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       trent.waddington@gmail.com
In-Reply-To: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3 (normal)
X-Mailer: SuSE Linux Openexchange Server 4 - WebMail (Build 2.4160)
X-Operating-System: Linux 2.4.21-314-smp i386 (JVM 1.3.1_19)
Organization: SuSE Linux AG
References: <200703200832.l2K8W3o5023643@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The floppy driver's sysfs file just provides some auxiliary
> information to user-space, none of which matters for most of
> its users. It is IMO totally inappropriate to fail floppy
> driver init in this case.

I thought it was for udev to create the device nodes? But
I might be wrong on that.

If it's ok to ignore such failures there sometimes then the warning
attribute should
be dropped. But just shutting the warning up is the wrong change.

Beides if floppy doesn't need sysfs for anything why does it
initialize sysfs? IMHO sysfs should be only used if there is a
good reason, otherwise it is just wasted memory.

-Andi


