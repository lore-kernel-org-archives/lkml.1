Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZBRAuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZBRAuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZBRAtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:49:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:13301 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755248AbZBRAts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:49:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="490790322"
Date: Tue, 17 Feb 2009 16:52:57 -0800
From: mark gross <mgross@linux.intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218005257.GC26292@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217064630.688bf639@infradead.org> <20090217145141.GA26158@srcf.ucam.org> <20090217065622.3e0a9956@infradead.org> <13B9B4C6EF24D648824FF11BE896716203771DD342@dlee02.ent.ti.com> <20090217160421.12bc851f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217160421.12bc851f@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 04:04:21PM -0800, Arjan van de Ven wrote:
> On Tue, 17 Feb 2009 09:32:46 -0600
> "Woodruff, Richard" <r-woodruff2@ti.com> wrote:
> 
> > > so use range timers / timer slack for those apps that you do not
> > > trust. That is not a big deal, and solves the issue of timer
> > > wakeups...
> > 
> > I not so sure it is that straight forward in practice.  End systems
> > integrate a lot of 3rd party software who view performance 1st and
> > have no thought of power.
> 
> you know that with the range timers/slack, you can control the
> "rounding" of the timer of the application, right?
> You can *directly* throttle the number of wakeups an application causes
> that way to a value you set.
> 

As the application code is mostly managed it should be a slam dunk to
make range timers work withing the android framework or Dalvik layers.

--mgross

