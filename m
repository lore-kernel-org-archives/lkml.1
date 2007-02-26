Return-Path: <linux-kernel-owner+w=401wt.eu-S1030397AbXBZS0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397AbXBZS0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXBZS0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:26:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030400AbXBZS0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:26:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Mon, 26 Feb 2007 19:28:18 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <20070226151442.GA29869@in.ibm.com> <20070226161129.GA527@tv-sign.ru>
In-Reply-To: <20070226161129.GA527@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261928.19274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 February 2007 17:11, Oleg Nesterov wrote:
> On 02/26, Srivatsa Vaddagiri wrote:
> >
> > On Mon, Feb 26, 2007 at 03:00:43PM +0300, Oleg Nesterov wrote:
> > > In that case we should also modify ____call_usermodehelper(), otherwise we have
> > > the same "deadlock" if it is frozen. But this is not so easy to do as I thought
> > > before.
> > 
> > Before ____call_usermodehelper can freeze, it should have entered userspace 
> > right? By that time, its vfork parent should have definitely woken up,
> > which should avoid the deadlock you point out?
> 
> Ah, yes, thanks for correcting me.
> 
> We are doing flush_old_exec() a way before entering userspace of course.

Well, does it mean the patch is acceptable or should I modify it somehow?

Rafael
