Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105Ab0ACVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0ACVco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973Ab0ACVcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:32:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50819 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0ACVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:32:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Borkmann <danborkmann@googlemail.com>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sun, 3 Jan 2010 22:33:19 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: =?iso-8859-2?q?Bart=B3omiej_Zimo=F1?= <uzi18@o2.pl>,
       Andy Walls <awalls@radix.net>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <65e5aef6.33251eb4.4b3fecf4.a2f99@o2.pl> <4B4063AB.7080401@gmail.com>
In-Reply-To: <4B4063AB.7080401@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001032233.19599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Daniel Borkmann wrote:
...
> Actually I think this is what signals are there for and bringing this
> information via signals would have least overhead, problem is that this
> is not POSIX compliant, but may be you could have a try at this?!

You need information to be passed both ways.

Namely, a power manager (be it a kernel module or a user space process) has
to communicate to the (other) processes that it's about to suspend and it
should wait for each of them to say that it's now OK to suspend.

You could do that with signals, but I guess it's not the easiest way. :-)

Rafael
