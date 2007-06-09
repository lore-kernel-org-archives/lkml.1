Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXFILhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXFILhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXFILgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:36:53 -0400
Received: from bay0-omc3-s3.bay0.hotmail.com ([65.54.246.203]:37181 "EHLO
	bay0-omc3-s3.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbXFILgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:36:52 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 07:35:56 -0400
From: Sean <seanlkml@sympatico.ca>
To: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading
 andmanipulation,pathname matching
Message-Id: <20070609073556.b58ca755.seanlkml@sympatico.ca>
In-Reply-To: <200706092026.CJH55869.NGPNtMTS@I-love.SAKURA.ne.jp>
References: <20070609011022.ac332fc7.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
	<20070609014454.2f1f2f91.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
	<20070609032822.bc420a84.seanlkml@sympatico.ca>
	<200706092026.CJH55869.NGPNtMTS@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 11:36:51.0682 (UTC) FILETIME=[79129C20:01C7AA8A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 20:26:57 +0900
Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp> wrote:

> Sean wrote:
> > All of a sudden you've implemented the main features of AA with very
> > few changes to the kernel.  It should be more maintainable, and much
> > easier to get accepted into the kernel.
> Do you agree with passing "struct vfsmount" to VFS helper functions and LSM hooks
> and introducing d_namespace_path() so that the AA extension can calculate the requested pathname
> and map the requested pathname to SELinux's labels?
> 

Frankly i'm not in a position to judge, but if that's the best way to provide
the desired functionality, then it sounds good.  But please make sure you
bounce this all off someone who actually knows what they're talking about. ;o)
Really I was just casually following along this ongoing conversation and had
a more conceptual/design question about how things were implemented.  A few
people explained how AA labelling at "runtime" wasn't conceptually very
different than what SELinux did.  All that begged the question as to why 
that functionality couldn't just be tacked on to SELinux?

Sean
