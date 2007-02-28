Return-Path: <linux-kernel-owner+w=401wt.eu-S1750872AbXB1AG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbXB1AG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXB1AG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:06:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXB1AG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:06:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 01:08:56 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Nigel Cunningham <nigel@suspend2.net>
References: <200702272251.28844.rjw@sisk.pl> <200702280057.36198.rjw@sisk.pl> <1172620896.3681.19.camel@johannes.berg>
In-Reply-To: <1172620896.3681.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702280108.57988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 01:01, Johannes Berg wrote:
> On Wed, 2007-02-28 at 00:57 +0100, Rafael J. Wysocki wrote:
> 
> > Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> > make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
> > the two XFS workqueues are affected).
> 
> I think Nigel might object but I forgot what specific trouble XFS was
> causing him.

We suspected that the XFS' worker threads might commit I/O after
freeze_processes() has returned, but that hasn't been supported by evidence,
as far as I can recall.

Also, making them freezable was controversial ...

Greetings,
Rafael
