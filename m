Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXDGIBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXDGIBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXDGIBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:01:05 -0400
Received: from fed1rmmtao107.cox.net ([68.230.241.39]:49462 "EHLO
	fed1rmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965509AbXDGIBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:01:04 -0400
From: Junio C Hamano <junkio@cox.net>
To: David Brownell <david-b@pacbell.net>
Subject: Re: coding style for long conditions
References: <11757099691323-git-send-email-tony@atomide.com>
	<200704061557.12662.david-b@pacbell.net>
	<1175901682.28263.507.camel@localhost.localdomain>
	<200704061634.39344.david-b@pacbell.net>
cc: tglx@linutronix.de, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Date: Sat, 07 Apr 2007 01:01:02 -0700
In-Reply-To: <200704061634.39344.david-b@pacbell.net> (David Brownell's
	message of "Fri, 6 Apr 2007 16:34:38 -0700")
Message-ID: <7v8xd4fwap.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

> So in practical terms "\n \t" and "\n\t" are identical;
> although the former "should not" be used, it doesn't
> actually affect what CodingStyle is primarily trying to
> control (i.e. what the code looks like).

That's not what CodingStyle is trying to control.  Not "what the
code looks like" at all.

Think why this line is here at the end of Chapter 1.

    Get a decent editor and don't leave whitespace at the end of lines.

By the way, "git show --color 0aa599c -- drivers/usb/net/usbnet.h"
would catch this kind of breakage if you have git.

