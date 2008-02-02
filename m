Return-Path: <linux-kernel-owner+w=401wt.eu-S1765061AbYBBI0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765061AbYBBI0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYBBI0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:26:37 -0500
Received: from 1wt.eu ([62.212.114.60]:1667 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbYBBI0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:26:36 -0500
Date: Sat, 2 Feb 2008 08:44:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.23.14
Message-ID: <20080202074406.GA31516@1wt.eu>
References: <479A83DE.8020002@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A83DE.8020002@davidnewall.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I've CC'd Greg, author of the driver.

On Sat, Jan 26, 2008 at 11:20:38AM +1030, David Newall wrote:
> I experienced major major data loss on a PL-2303 USB-serial converter
> under 2.4.36, which I remedied by back-porting the pl2303.c from the
> latest 2.6 kernel tree.

I'm OK to merge your work in 2.4.36.1 if it fixes bugs for you. I would have
hoped a little more feedback from other users, but let's face it, people
using USB are most often on desktops running 2.6.

I've noticed your other mail about the buffer overflow (which does not
sound like an overflow as we call it in security terms, so it's not
critical). It would be better to merge your work with the fix in it,
but I'll wait for the fix to be in 2.6 first (so that people upgrading
from 2.4 to 2.6 never experience a regression).

If this buffer overflow was not present in 2.4 driver but only in 2.6
(and in the backport), I'd rather wait in order not to break behaviour
for current users of the driver. If both have the same bug, and if Greg
is OK, then let's merge your work as a first evolution before a common
fix.

Based on the above conditions, I'd like you to tell Greg and I if you
consider it worth to merge this backport in 2.4 now. From my point of
view, your work looks OK but I want your feedback as a user (and not
as the backporter), then Greg's approval.

Thanks,
Willy

