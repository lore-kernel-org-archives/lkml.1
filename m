Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZEaJAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZEaJAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 05:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZEaJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 05:00:27 -0400
Received: from pearlgates.net ([83.163.47.93]:39714 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbZEaJA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 05:00:26 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 May 2009 05:00:26 EDT
Date: Sun, 31 May 2009 10:52:27 +0200
From: Angel <angel@pearlgates.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI
 enabled
Message-Id: <20090531105227.178e5397.angel@pearlgates.net>
In-Reply-To: <PkPeJtNB3KO.A.CSH.sWbIKB@chimera>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
	<PkPeJtNB3KO.A.CSH.sWbIKB@chimera>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 21:55:34 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12947
> Subject		: r128: system hangs when X is started with DRI enabled
> Submitter	: Jos van der Ende <seraph@xs4all.nl>
> Date		: 2009-03-26 16:14 (66 days old)


We've found a working bug fix for 2.6.29 which I expect will be included in the next bug fix release. However, 2.6.30-rc[1-7] (which already includes this fix) introduced a new problem which we're still working on.

The bug fix in question is this one:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=42beefc00


-- 
Angel <angel@pearlgates.net>
