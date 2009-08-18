Return-Path: <linux-kernel-owner+w=401wt.eu-S1751128AbZHRVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbZHRVba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZHRVba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:31:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHRVb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:31:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miles Lane <miles.lane@gmail.com>
Subject: Re: 2.6.31-rc6-git2 -- PM: Preparing system for mem sleep -- [<10af497>] ? sync_buffer+0x0/0x37
Date: Tue, 18 Aug 2009 23:32:12 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Cedric Le Goater <legoater@free.fr>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pavel Machek <pavel@ucw.cz>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <a44ae5cd0908172059mba5121rdcea6af86d9f85ab@mail.gmail.com>
In-Reply-To: <a44ae5cd0908172059mba5121rdcea6af86d9f85ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908182332.12977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Miles Lane wrote:
> I'll send my .config file separately.  I am afraid that including it
> in this message might cause VGER to reject it.
...
> Aug 17 21:27:12 ubuntu kernel: [26639.211086]  nm-applet
> Aug 17 21:27:12 ubuntu kernel: [26639.211360]
> Aug 17 21:27:12 ubuntu kernel: [26639.211365] Restarting tasks ... done.

You had nm-applet in TASK_UNINTERRUPTIBLE.

Is this reproducible?

Rafael
