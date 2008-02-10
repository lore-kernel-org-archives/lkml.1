Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYBJCDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYBJCDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 21:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYBJCC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 21:02:58 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1240 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYBJCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 21:02:47 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "David Newall" <davidn@davidnewall.com>
Cc: "Greg KH" <greg@kroah.com>, "Christer Weinigel" <christer@weinigel.se>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only
Date: Sat, 9 Feb 2008 18:01:51 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <1202514072.15090.359.camel@violet>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 09 Feb 2008 18:03:15 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 09 Feb 2008 18:03:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Marcel Holtmann wrote:

> Lets phrase this in better words as Valdis pointed out: You can't
> distribute an application (binary or source form) under anything else
> than GPL if it uses a GPL library.

This simply cannot be correct. The only way it could be true is if the work
was a derivative work of a GPL'd work. There is no other way it could become
subject to the GPL.

So this argument reduces to -- any work that uses a library is a derivative
work of that library. But this is clearly wrong. For work X to be a
derivative work of work Y, it must contain substantial protected expression
from work Y, but an application need not have any expression from the
libraries it uses.

> It makes no difference if you
> distribute the GPL library with it or not.

If you do not distribute the GPL library, the library is simply being used
in the intended, ordinary way. You do not need to agree to, nor can you
violate, the GPL simply by using a work in its ordinary intended way.

If the application contains insufficient copyrightable expression from the
library to be considered a derivative work (and purely functional things do
not count), then it cannot be a derivative work. The library is not being
copied or distributed. So how can its copyright be infringed?

> But hey (again), feel free to disagree with me here.

This argument has no basis in law or common sense. It's completely
off-the-wall.

And to Pekka Enberg:

>It doesn't matter how "hard" it was to write that code. What matters
>is whether your code requires enough copyrighted aspects of the
>original work to constitute as derived work. There's a huge difference
>between using kmalloc and spin_lock and writing a driver that is built
>on to of the full USB stack of Linux kernel, for example.

The legal standard is not whether it "requires" copyrighted aspects but
whether it *contains* them. The driver does not contain the USB stack. The
aspects of the USB stack that the driver must contain are purely
functional -- its API.

You simply can't have it both ways. If the driver must contain X in order to
do its job, then X is functional and cannot make the driver a derivative
work. You cannot protect, by copyright, every way to accomplish a particular
function. Copyright only protects creative choices among millions of (at
least arguably) equally good choices.

DS


