Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666Ab0ABNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0ABNpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475Ab0ABNpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:45:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0ABNpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:45:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vikram Dhillon <dhillonv10@gmail.com>
Subject: Re: [Bug #14940] cfq-iosched: tiobench regression
Date: Sat, 2 Jan 2010 14:46:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <200912302253.53285.rjw@sisk.pl> <ea6602021001011757y21c6b859ocdbea233070fb31c@mail.gmail.com>
In-Reply-To: <ea6602021001011757y21c6b859ocdbea233070fb31c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001021446.17801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Vikram Dhillon wrote:
> On Wed, Dec 30, 2009 at 4:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 30 December 2009, Jens Axboe wrote:
> >> On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> >> > This message has been generated automatically as a part of a report
> >> > of recent regressions.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > from 2.6.32.  Please verify if it still should be listed and let me know
> >> > (either way).
> >> >
> >> >
> >> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=14940
> >> > Subject             : cfq-iosched: tiobench regression
> >> > Submitter   : Shaohua Li <shaohua.li@intel.com>
> >> > Date                : 2009-12-24 0:55 (6 days old)
> >> > References  : http://marc.info/?l=linux-kernel&m=126161612401994&w=4
> >>
> >> I don't think this should be labelled as a regression. It was already
> >> known that we'd have less throughput for the many clients cases, it was
> >> a trade off that was made to improve latencies.
> >
> > OK, I've closed it as "documented".
> >
> > Rafael
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> Thanks for this update, I guess we I can make like a separate category
> of documented regressions because this could be helpful to other
> distributions as they update to the newer kernels :D

That actually is easy to get.  ;-)

* Go to bug #14885, which is a meta-bug for post-2.6.32 regressions.
* Go to the dependency tree.
* Click on "Show resolved".
* Click on "view as bug list".
* Search for "DOCU".

Rafael
