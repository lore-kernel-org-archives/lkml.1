Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbXB1BOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbXB1BOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXB1BOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:14:20 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:33421 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXB1BOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:14:19 -0500
Subject: Re: Problem with freezable workqueues
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <200702280108.57988.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
	 <200702280057.36198.rjw@sisk.pl> <1172620896.3681.19.camel@johannes.berg>
	 <200702280108.57988.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 12:14:14 +1100
Message-Id: <1172625254.8580.37.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-02-28 at 01:08 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 28 February 2007 01:01, Johannes Berg wrote:
> > On Wed, 2007-02-28 at 00:57 +0100, Rafael J. Wysocki wrote:
> > 
> > > Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> > > make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
> > > the two XFS workqueues are affected).
> > 
> > I think Nigel might object but I forgot what specific trouble XFS was
> > causing him.
> 
> We suspected that the XFS' worker threads might commit I/O after
> freeze_processes() has returned, but that hasn't been supported by evidence,
> as far as I can recall.
> 
> Also, making them freezable was controversial ...

Controversy is no reason to give in! Nevertheless, I think you're right
- I believe the XFS guys said they fixed the issue that had caused I/O
to be submitted post-freeze. Well, we'll see if it appears again, won't
we?

Regards,

Nigel

