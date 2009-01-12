Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZALP4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZALP4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZALP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:56:18 -0500
Received: from corega.com.ru ([195.178.208.66]:49279 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZALP4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:56:17 -0500
Date: Mon, 12 Jan 2009 18:56:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112155615.GA21350@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112155239.5f677a17@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:52:39PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Which has to be checked for every process ever created,
> > which is quite unfeasible in some conditions.
> 
> The task name is not a reliable indicator of true name and truncated so
> is useless. You only nominate one task, you don't integrate with the
> existing interface.

Not one, but tasks which have the given string in the name. Like script
names spawned at DoS time.

> What you actually need is notifiers to work on /proc (exactly the same as
> we need to avoid the bogus waitfd crap). At that point you can implement
> arbitary policy by using dnotify/inotify/etc on /proc.

Yes, it could be done. If inotify will not be killed itself, will be
enabled in the config and daemon will be started.
But right now there is no way to solve that task, in the long term this
is a good idea to implement modulo security problems it may concern.

-- 
	Evgeniy Polyakov
