Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXBDH5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXBDH5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 02:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXBDH5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 02:57:33 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1275 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXBDH5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 02:57:32 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Sat, 3 Feb 2007 23:56:43 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCELOBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <Pine.LNX.4.61.0702032136430.13874@yvahk01.tjqt.qr>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 23:56:58 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 23:57:00 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Feb 3 2007 10:31, David Schwartz wrote:
> >
> >The way out of the GPL problem is to make clear that it is *not* a
> >copyright enforcement scheme
>
> So why do we have EXPORT_SYMBOL_GPL then, if
>
>   -  there shall be no enforcement (such as requiring modules to carry
>      exactly one MODULE_LICENSE, and it be GPL to access GPL symbols)
>
>   -  EXPORT_SYMBOL_GPL can be circumvented by having multiple
>      MODULE_LICENSE and one of those MODULE_LICENSE is ("GPL")
>      [see Bodo's patch]

The same reason we do any other checks. Why don't we let a normal use list
the contents of any directory they want to? Because we believe that allowing
people to do that, in the default shipping configuration, has disadvantages
that outweight the benefits. If someone disagrees, they are free to remove
the check or bypass it or whatever, by then they take those risks.

> I think Linus has made a stance on the purpose of _GPL [yup,
> http://lkml.org/lkml/2003/12/4/84 ], and I interpret his words "if you
> need this export, you're clearly doing something that requires the GPL"
> being in conflict with [X].

Exactly. It conveys the opinion of whoever set the tag that they believe it
is difficult to impossible to use that symbol in anything other than a
derived work. It is, to some extent, misnamed because the GPL does not
require all derived work to be placed under the GPL. (For example, a derived
work that is never distributed need not be placed under the GPL.)

> Note IANAL, more a developer, so please don't flame too much.

No, you're dead on.

Why don't we allow a normal user to unlink any file? Because the person who
put in the check to prevent that believes that that's not something you
should be doing. If you *want* to do it, it's your right. But it is also
their right to put in the code that stops you, so that you have to *want* to
do it in order to do it.

The GPL allows me to add code and distribute and it allows you to remove
that same code if you want. If you disagree with my judgment, you may bypass
it at your own risk.

DS


