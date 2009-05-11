Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZEKX3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZEKX3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZEKX2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:28:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36405 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbZEKX2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:28:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Tue, 12 May 2009 01:28:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, mel@csn.ul.ie
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905120044.37342.rjw@sisk.pl> <20090511160704.e1fa2512.akpm@linux-foundation.org>
In-Reply-To: <20090511160704.e1fa2512.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120128.16780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Andrew Morton wrote:
> On Tue, 12 May 2009 00:44:36 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Which means this patch:
> > http://marc.info/?l=linux-kernel&m=124165031723627 (it also is my favourite
> > one).
> 
> ho hum, I could live with that ;)
> 
> Would it make sense to turn it into something more general?  Instead of
> "tasks_frozen/processes_are_frozen()", present it as
> "oom_killer_disabled/oom_killer_is_disabled()"?
> 
> That would invite other subsystems to use it, if they want to.  Which
> might well be a bad thing on their behalf, hard to say..

I chose the names this way because the variable is defined in the freezer code.

Alternatively, I can define one in page_alloc.c, add [disable|enable]_oom_killer()
for manipulating it and call them from the freezer code.  Do you think that
would be better?
