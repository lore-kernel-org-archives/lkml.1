Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZELUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZELUlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZELUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:41:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZELUlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:41:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Tue, 12 May 2009 22:40:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, mel@csn.ul.ie
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905121852.37224.rjw@sisk.pl> <20090512105059.30fb93c2.akpm@linux-foundation.org>
In-Reply-To: <20090512105059.30fb93c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905122240.33384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Andrew Morton wrote:
> On Tue, 12 May 2009 18:52:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Well, what about the following?
> 
> It has the virtue of simplicity.
> 
> > +static inline void disable_oom_killer(void)
> > +{
> > +	oom_killer_disabled = true;
> > +}
> > +
> > +static inline void enable_oom_killer(void)
> > +{
> > +	oom_killer_disabled = false;
> > +}
> 
> I'll change these to oom_killer_disable() and oom_killer_enable(), OK?

Works for me, thanks!
