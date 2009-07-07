Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZGGK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZGGK6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZGGK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:58:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZGGK6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:58:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Tue, 7 Jul 2009 12:58:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.ZFB.BCpUKB@chimera> <1246925538.4652.8.camel@johannes.local>
In-Reply-To: <1246925538.4652.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071258.33579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Johannes Berg wrote:
> On Tue, 2009-07-07 at 02:00 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
> > Subject		: hibernate slow on _second_ run
> > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > Date		: 2009-05-14 09:34 (54 days old)
> 
> Still exists in 31-rc2.

Thanks for the update.

Last time I remember you managed to collect some ftrace output from the failing
case, but they didn't reveal anything directly.

We know, however, that is [suspend|resume]_device_irqs() in
driver/base/power/main.c are disabled, the issue doesn't show up.

Is that correct?

Rafael
