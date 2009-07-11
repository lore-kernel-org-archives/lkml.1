Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZGKSuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZGKSuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZGKSu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:50:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZGKSuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:50:25 -0400
Subject: Re: inotify regression, missing events
From: Eric Paris <eparis@redhat.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1247328127.4003.6.camel@wing-commander>
References: <1247328127.4003.6.camel@wing-commander>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 07:50:19 -0400
Message-Id: <1247313019.2791.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 17:02 +0100, Scott James Remnant wrote:
> Hey folks,
> 
> Looks like there's a regression with inotify since the rewrite to use
> fanotify.  Events are simply missing and not being delivered to
> userspace.
> 
> Here's a simple test case, just compile and run it:

I bet I know exactly what it is (notification.c tail merge code isn't
comparing filename only inode+mask) but I'm walking out of the house.
I'll try my theory later tonight and post a patch.

Stupid Eric, Stupid.

-Eric

