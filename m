Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZALQ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZALQ3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZALQ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:29:41 -0500
Received: from tservice.net.ru ([195.178.208.66]:59693 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZALQ3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:29:40 -0500
Date: Mon, 12 Jan 2009 19:29:38 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112162938.GA22647@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 04:19:31PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Yes, it could be done. If inotify will not be killed itself, will be
> > enabled in the config and daemon will be started.
> > But right now there is no way to solve that task, in the long term this
> > is a good idea to implement modulo security problems it may concern.
> 
> It is perfectly soluble right now, use the existing /proc interface. If
> you want to specifically victimise new tasks first then set everything
> else with an adjust *against* being killed and new stuff will start off
> as cannon fodder until classified.
> 
> The name approach is the wrong way to handle this. It has no reflection
> of heirarchy of process, targetting by users, containers etc.. 
> 
> In fact containers are probably the right way to do it

Containers to solve oom-killer selection problem? :)

Being more serious, I agree that having a simple name does not solve the
problem if observed from any angle, but it is not the main goal.
Patch solves oom-killer selection issue from likely the most commonly
used case: when you know who should be checked and killed first when
problem appears.

-- 
	Evgeniy Polyakov
