Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZHJPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZHJPSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZHJPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:18:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751905AbZHJPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:18:30 -0400
Date: Mon, 10 Aug 2009 11:18:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090808194733.38406075@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009, Bruno [UTF-8] Prémont wrote:

> I tried bisecting this but bisect did end up on a fully unrelated commit
> (which is not even being compiled into my kernel).
> Possibly the failed bisect could be related to mis-classified kernel
> panic/hang while pulling the USB cable (there were two such panics for the
> whole iteration)?
> 
> There are quite a few patches touching tty, ttyUSB and friends between
> rc4 and now so pretty hard to guess on the correct one.
> 
> The oops always happens when I disconnect the USB serial console (here
> the one built into Marvell SheevaPlug) while having minicom connected
> to it.
> During the bisection for the last few bad iterations minicom got killed
> (segfault), the bad ones on the iteration left a minicom zombie in 'D'
> state.

By the way, there are quite a few serial patches in Greg KH's tree.  At 
least one of them looks like it is meant to fix exactly this problem.

Can you try running with

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-all-2.6.31-rc5.patch

applied to the standard 2.6.31-rc5 source?

Alan Stern

