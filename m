Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXLHKpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXLHKpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXLHKps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:45:48 -0500
Received: from tim.rpsys.net ([194.106.48.114]:58954 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXLHKpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:45:47 -0500
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
From: Richard Purdie <rpurdie@rpsys.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 08 Dec 2007 10:44:38 +0000
Message-Id: <1197110678.4665.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-08 at 03:40 +0100, Rafael J. Wysocki wrote:
> Subject		: leds: ledtrig-timer calls sleeping function from invalid context
> Submitter	: Márton Németh <nm127@freemail.hu>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
> Handled-By	: Richard Purdie <rpurdie@rpsys.net>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view

The fix is now in mainline:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dc47206e552c0850ad11f7e9a1fca0a3c92f5d65

Cheers,

Richard



