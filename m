Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXB0REQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXB0REQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXB0REP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:04:15 -0500
Received: from web52907.mail.yahoo.com ([206.190.49.17]:32287 "HELO
	web52907.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751701AbXB0REO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:04:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FS9/skGyKgfRVN3PPFw4FtuwWNg8Lb5H3Dh0J/KgFg2YnwPmDWJJ7yljAqBIvDUFcA2EEjsElZBlU/DZg6QbKkw5UntWt0+OBIYcGoR8spP0Mu1FuriNaHKk5LMB7rtxCoGYFKxfZfb+lHO0M9hBt/ftIKXbKyayWhsOB5z5EYM=;
X-YMail-OSG: cO608V0VM1n8MXm.MGg5clLNKpbtdCBT90IsNdAm
Date: Tue, 27 Feb 2007 17:04:12 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <84144f020702270642q4e371175y2a6c922e030e1f3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <714641.9150.qm@web52907.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Call Trace:
> >  [<c01839fe>] sysfs_release+0x2d/0x4c
> >  [<c015124b>] __fput+0x96/0x13c
> 
> So udevd is closing a sysfs attribute file but the pointer passed to
> module_put is bogus. Looks like the sysfs dentry was already taken
> down by release_sysfs_dirent(). Can you reproduce this at will? Does
> the oops happen in older kernels?

No, unfortunately I can't. Last night was the first time this ever happened (while I was starting
up World of Warcraft/Wine), so I have no idea which sysfs attribute it is talking about here.

Cheers,
Chris



		
___________________________________________________________ 
Inbox full of unwanted email? Get leading protection and 1GB storage with All New Yahoo! Mail. http://uk.docs.yahoo.com/nowyoucan.html
