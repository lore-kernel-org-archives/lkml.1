Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbXLHJrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbXLHJrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXLHJqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:46:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbXLHJqy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:46:54 -0500
Date: Sat, 8 Dec 2007 01:46:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208014638.c4cddf12.akpm@linux-foundation.org>
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
> 
> 
> ..
>
> Subject		: system hangs after a few minutes
> Submitter	: Marcus Better <marcus@better.se>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
> Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> 		  Alan Stern <stern@rowland.harvard.edu>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13871&action=view
> 

This one we have a confirmed fix from Alan but it doesn't appear to be in
anyone's tree.

There is a second bug in here, applicable to core x86: Marcus's machine
won't boot with nmi_watchdog=1.

