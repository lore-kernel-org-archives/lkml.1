Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbXCYFHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbXCYFHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXCYFHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:07:17 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2086 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151AbXCYFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:07:15 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: About GCC4 Optimization
Date: Sat, 24 Mar 2007 22:07:05 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEEGCIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0703242123310.6730@woody.linux-foundation.org>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 24 Mar 2007 22:07:14 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 24 Mar 2007 22:07:15 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So what gcc does may be technically legal, but it's still a horribly
> bad thing to do. Sadly, some gcc people seem to care more
> about "letter
> of the law" than "sanity and quality of implementation".

You know, it would be one thing if they were consistent. A policy that, by
default, you get all the optimizations the relevant standards allow wouldn't
be a problem. But they do this when they feel like it, and they disable
significant optimizations even where the standards allow them when they feel
like that.

See, for example:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=20099

"You cannot create code that works with this option and doesn't work without
it except by violating the POSIX standard. So POSIX code should not have
this option enabled by default -- it's a pure pessimization." Yet the option
is on by default when -pthreads is specified.

DS

PS: Yes, I'm still pissed about this. ;)


