Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZGWAf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZGWAf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZGWAf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:35:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33261 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZGWAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:35:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 09:33:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       hugh.dickins@tiscali.co.uk, avi@redhat.com,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: Re: [PATCH 0/2] ZERO PAGE again v4.
Message-Id: <20090723093334.3166e9d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722171245.d5b3a108.akpm@linux-foundation.org>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
	<20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
	<20090723085137.b14fe267.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722171245.d5b3a108.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 17:12:45 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 23 Jul 2009 08:51:37 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 16 Jul 2009 18:01:34 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > 
> > > Rebased onto  mm-of-the-moment snapshot 2009-07-15-20-57.
> > > And modifeied to make vm_normal_page() eat FOLL_NOZERO, directly.
> > > 
> > > Any comments ?
> > > 
> > 
> > A week passed since I posted this.
> 
> I'm catching up at a rate of 2.5 days per day.  Am presently up to July
> 16.  I never know whether to work through it forwards or in reverse.
> 
> Geeze you guys send a lot of stuff.  Stop writing new code and go fix
> some bugs!
> 
In these months, I myself don't write any new feature.
I'm now in stablization stage.
(ZERO_PAGE is not new feature in my point of view.)

Remainig big one is Direce-I/O v.s. fork() fix.

> > It's no problem to keep updating this
> > and post again. But if anyone have concerns, please notify me.
> > I'll reduce CC: list in the next post.
> 
> ok...
> 
I'll postpone v5 until the next week.

Thank you for your efforts.

BTW, when I post new version, should I send a reply to old version to say
"this version is obsolete" ? Can it make your work easier ? like following.

Re:[PATCH][Obsolete] new version weill come (Was.....)

I tend to update patches until v5 or more until merged.

Regards,
-Kame

