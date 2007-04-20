Return-Path: <linux-kernel-owner+w=401wt.eu-S1767228AbXDTVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767228AbXDTVJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993330AbXDTVJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:09:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993319AbXDTVJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:09:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Date: Fri, 20 Apr 2007 23:13:38 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, ego@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070420103052.686f3c71.akpm@linux-foundation.org> <20070420183118.GA695@elte.hu>
In-Reply-To: <20070420183118.GA695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704202313.39243.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 April 2007 20:31, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN, 
> > > > PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two 
> > > > more for the freezer-based CPU hotplug, so if yet another one is 
> > > > needed, that will make up almost a separate u8 field ...
> > > 
> > > I am perfectly ok with it. But I am not sure if everybody would 
> > > agree to have another field in the task struct, though in this case 
> > > it does make sense :-)
> > 
> > OK by me.  You might want to consider making that fields's locking 
> > protocol be set_bit(), clear_bit(), etc rather than task_lock().
> 
> is OK to me too, the extra field isnt a problem.

OK, so I'll try to prepare a patch introducing it over the weekend. :-)

Greetings,
Rafael
