Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0BOUpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:45:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36380 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab0BOUpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:45:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #14999] possible circular locking dependency detected in rfkill at suspend
Date: Mon, 15 Feb 2010 21:45:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Tejun Heo" <tj@kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera> <4un6Gst5rKB.A.Im.WkIeLB@chimera> <m1wryed9w0.fsf@fess.ebiederm.org>
In-Reply-To: <m1wryed9w0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152145.58184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
> > Subject		: possible circular locking dependency detected in rfkill at suspend
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2010-01-06 21:52 (40 days old)
> 
> I have a set of patches to clear up the sysfs lockdep false positives.  
> http://lkml.org/lkml/2010/2/11/329
> 
> It requires sprinking a bunch of sysfs_attr_init on the few dynamically
> allocated sysfs attributes, and I haven't found them all yet.  Otherwise
> it seems to be working well.
> 
> Greg should pick up those patches shortly and they should be appearing
> in linux-next and then ultimately in 2.6.34.

Great, I'm glad that these issues are being worked on.

Thanks for the information.

Rafael
