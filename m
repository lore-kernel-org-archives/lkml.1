Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYLIRGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYLIRGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYLIRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:05:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52253 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbYLIRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:05:52 -0500
Date: Tue, 9 Dec 2008 17:05:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
Message-ID: <20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
In-Reply-To: <493EA441.1070706@redhat.com>
References: <493EA441.1070706@redhat.com>
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

> prototype for a fourth: waitfd. It pretty much does what the name 
> suggests: reading from it yields a series of status ints (as would be 
> written into the second argument of waitpid) for child processes that 
> have changed state. It takes essentially the same arguments as waitpid 
> (for now) and supports the same set of features.

This propogates the fundamental braindamage of waitpid - the fact the
notification only works on child process trees.

Here is a more elegant suggestion - use epoll, inotify and friends  fully
on /proc process nodes.

Alan


