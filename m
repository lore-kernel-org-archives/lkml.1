Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbXLILy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbXLILy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 06:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXLILyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 06:54:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbXLILyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 06:54:51 -0500
Date: Sun, 9 Dec 2007 03:54:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071209035415.a3875df8.akpm@linux-foundation.org>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of.

Here's one for you - I have a new Lenovo t61p with which to irritate
everyone. 

suspend-to-ram is a wipeout, but suspend-to-disk works OK under
2.6.23.

However under 2.6.24-rc1 and -rc4 the machine reboots right at the end of
resume-from-disk.

Am trying to do a git-disect on it but it seems that someone has been
screwing with ata Kconfig and I'm hitting a pile of cant-find-root-disk
bisection points and I can't immediately work out why.  I'll try to find
time to look at it again next week.

