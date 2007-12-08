Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXLHJ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXLHJ34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXLHJ3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:29:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbXLHJ3r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:29:47 -0500
Date: Sat, 8 Dec 2007 01:29:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?B?TeFydG9uIE7pbWV0aA==?= <nm127@freemail.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208012922.adb70db2.akpm@linux-foundation.org>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of.  If any of them have been fixed already, please let me
> know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.

Twenty nine, huh?

It would be useful if these records were sorted in date-of-reportage order
and had a date stamp so we could see how long they've been hanging about.
Something to think about for the post-2.6.24 regression if you'll be handling
those?

> Subject		: leds: ledtrig-timer calls sleeping function from invalid context
> Submitter	: Márton Németh <nm127@freemail.hu>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
> Handled-By	: Richard Purdie <rpurdie@rpsys.net>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view

That patch has been merged (dc47206e552c0850ad11f7e9a1fca0a3c92f5d65) and
assuming Márton has tested the latest git snapshot
(ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots) successfully we can
cross it off?  
