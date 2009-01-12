Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZALQTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZALQTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZALQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:19:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38110 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752377AbZALQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:19:21 -0500
Date: Mon, 12 Jan 2009 16:19:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090112155615.GA21350@ioremap.net>
References: <20090112153304.GA19995@ioremap.net>
	<20090112154922.6003750b@lxorguk.ukuu.org.uk>
	<20090112155030.GA21063@ioremap.net>
	<20090112155239.5f677a17@lxorguk.ukuu.org.uk>
	<20090112155615.GA21350@ioremap.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, it could be done. If inotify will not be killed itself, will be
> enabled in the config and daemon will be started.
> But right now there is no way to solve that task, in the long term this
> is a good idea to implement modulo security problems it may concern.

It is perfectly soluble right now, use the existing /proc interface. If
you want to specifically victimise new tasks first then set everything
else with an adjust *against* being killed and new stuff will start off
as cannon fodder until classified.

The name approach is the wrong way to handle this. It has no reflection
of heirarchy of process, targetting by users, containers etc.. 

In fact containers are probably the right way to do it
