Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZBRAmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZBRAmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZBRAmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:42:31 -0500
Received: from mga10.intel.com ([192.55.52.92]:2657 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbZBRAma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:42:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="666380177"
Date: Tue, 17 Feb 2009 16:45:47 -0800
From: mark gross <mgross@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218004547.GB26292@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:23:30PM +0000, Matthew Garrett wrote:
> On Tue, Feb 17, 2009 at 12:19:38AM +0100, Rafael J. Wysocki wrote:
> 
> > This, again, seems to be a bit x86-centric. :-)  The Android people are telling
> > us that on the hardware they deal with it does make sense to put the entire
> > system to sleep even for relatively short periods of time, since the latencies
> > involved are not too bad.
> 
> Arve said that the power state was equivalent in idle and suspend, but 
> that they preferred suspend because it stopped any periodic timers. I'd 
> be more interested in making sure that unnecessary timers aren't running 
> than focusing on automatically entering system-wide suspend - Nokia have 
> been managing this since 2005 with good results.
>

I think they where talking timers as hardware devices pulling electrons,
not SW timers triggering wake ups.  I guess the timer hardware could be
running, and pulling power, even when not programmed to trigger any
event or IRQ.

--mgross
