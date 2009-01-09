Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZAIOzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZAIOzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZAIOy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:54:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37208 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZAIOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:54:59 -0500
Date: Fri, 9 Jan 2009 16:09:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>, bfields@fieldses.org
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090109150911.GC26290@one.firstfloor.org>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20090108162806.48caaa29@bike.lwn.net> <20090109100821.GA27829@redhat.com> <20090109061846.5beee8df@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109061846.5beee8df@bike.lwn.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Now we have the global mutex for ->fasync... Well, not very
> > good but fasync_helper() takes fasync_lock anyway.
> 
> Not very good, but does anybody know of a workload which would result in
> that mutex being contended ever?

I presume it could be a problem on a program that uses asynchronous sockets
multi threaded. At some point that used to be a common pattern for
network servers like squid (not saying that it's necessarily contended
in squid itself)

-andi

-- 
ak@linux.intel.com
