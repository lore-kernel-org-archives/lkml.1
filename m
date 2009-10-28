Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZJ1Spu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZJ1Spu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZJ1Spt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:45:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbZJ1Sps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:45:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: jim owens <jowens@hp.com>
Subject: Re: [Bug #14474] restorecond going crazy on 2.6.31.4 - inotify regression?
Date: Wed, 28 Oct 2009 19:47:31 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Eric Paris <eparis@parisplace.org>, Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <200910272127.40587.rjw@sisk.pl> <4AE84017.7040101@hp.com>
In-Reply-To: <4AE84017.7040101@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281947.31777.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, jim owens wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 27 October 2009, Eric Paris wrote:
> >> It's a restorecond bug.  restorecon acted as if watch descriptors
> >> could never be reused.  They weren't on old kernels and it's possible
> >> they are reused now.  Restorecon was fixed.
> >>
> >> http://marc.info/?l=selinux&m=125380417916233&w=2
> >>
> >> a change in the kernel caused a buggy userspace program to break.  I
> >> know how to put the kernel back the way it was, but I don't know if we
> >> call this a regression, you guys tell me.
> > 
> > Yes, we do, AFAICS.  The policy is not to break user space, even if it happens
> > to work by accident.
> 
> But if we make a rule of "never break even bad user programs" then
> we also should never plug security holes because that breaks a
> user program expecting that attack vector :)

Well, that's why this rule is not carved in stone.

Clearly, there are some cases in which we can't afford keeping the buggy user
space happy, not only security-related.

Thanks,
Rafael
