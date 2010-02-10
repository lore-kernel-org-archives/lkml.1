Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0BJAps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:45:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0BJApp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:45:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.33-rc6 crashes on resume
Date: Wed, 10 Feb 2010 01:46:19 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4B70982F.8090208@roadwarrior3.tmr.com> <201002090009.50118.rjw@sisk.pl> <4B71EBD8.8070406@tmr.com>
In-Reply-To: <4B71EBD8.8070406@tmr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100146.19955.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, Bill Davidsen wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 09 February 2010, Bill Davidsen wrote:
> >> Pretty simple to reproduce, boot, suspend, press shift
> >>
> >> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.
> > 
> > I guess 2.6.32 didn't crash?
> > 
> Wasn't testing. 2.6.32.5 didn't crash, later Fedora kernels kill the touchpad, I 
> can dig up the old bugzilla if you can't find it.

Well, so it seems something during the 2.6.33 merge window broke things for
you.

Unfortunately there have been quite a few resume regressions of all sorts in
this cycle, so bisecting that might be difficult.  That said, bisection would
probably be the fastest way of debugging this issue.

Rafael
