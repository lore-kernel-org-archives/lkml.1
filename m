Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXDLFBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXDLFBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030688AbXDLFBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:01:03 -0400
Received: from [212.12.190.116] ([212.12.190.116]:32813 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030672AbXDLFBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:01:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 08:04:34 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704120804.34551.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pedro wrote:
> On Wednesday 11 April 2007 16:48, Willy Tarreau wrote:
> > On Wed, Apr 11, 2007 at 02:23:31AM -0300, Pedro wrote:
> > >
> > >   As the OOM killer is not Posix,
> >
> > If you cannot control your application's memory usage, you'll have to
> > finely tune the overcommit_ratio.
>
>   2) How should an application be written to not be killed by OOM?


Try this:

# echo -17 > /proc/<pid>/oom_adj

Or this:

# echo 2 > /proc/sys/vm/overcommit_memory
# echo 95 > /proc/sys/vm/overcommit_ratio

Or this:

# ulimit -v [max vm]


Thanks, and good luck with the OOM killer!


--
Al

