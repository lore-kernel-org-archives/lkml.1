Return-Path: <linux-kernel-owner+w=401wt.eu-S1161244AbXBOU4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161244AbXBOU4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161079AbXBOU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:56:36 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4240 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161244AbXBOU4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:56:34 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Ben Nizette" <ben.nizette@iinet.net.au>
Cc: "v j" <vj.linux@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Thu, 15 Feb 2007 12:56:26 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEPFBJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45D40E81.3050506@yahoo.com.au>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 15 Feb 2007 12:56:47 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 15 Feb 2007 12:56:47 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Question to the world here:  Distros make, as a matter of course, a
> > series of modifications to the Linux Kernel so that their modules or
> > features work.  What stops VJ making a patchset which effectively
> > s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g 's the kernel source then
> > distributing that under the GPL?  He then supplies his un-GPL'd modules
> > to the world which just happen to only run on the modified
> > kernel.

> The best bet would be to read up on lots of past discussions related to
> exactly these kinds of questions, then ask your Lawyer.

> Rhetorical question: what stops me from taking somebody's copyrighted
> work, stripping the copyrights or falsely claiming to have a license
> to redistribute it, then selling it?

Totally unrelated for so many reasons:

1) EXPORT_SYMBOL_GPL is not a copyright. Removing functional code is not
even remotely analogous to "stripping copyrights".

2) Falsely claiming to have a license is not the same thing as actually
having a license. The GPL is a license.

> > I've
> > read the GPL of course (IANAL though) and I can't see what this
> > violates
> > except the /spirit/ of the license.

On the contrary, being allowed to change the code if you don't like what it
does *is* the spirit of the GPL. Being able to share those changes *is* the
spirit of the GPL. It's those who try to contaminate GPL'd code with
*functional* *aspects* they wish to use the law to stop people from
circumventing who are violating the spirit of the GPL.

> > Don't get me wrong, I'm strongly
> > against anyone doing what I just mentioned, I believe it to be immoral
> > taking someone's GPL'd code and mangling it in such a way.

The whole point of the GPL is to ensure the freedom to mangle code to make
it do what you want and not do what you don't want. The whole point is to
people from adding things that others cannot remove.

> > I speak as
> > an embedded developer myself whose company decided that running
> > your code
> > under Linux and distributing our code under the GPL was far preferable
> > to running closed-source software on a closed-source platform.

I agree. I think a lot of people choose not to open source their commercial
software for reasons that really don't make sense and they don't appreciate
the advantages. To the person who said that "open sourcing our code only
helps our competitors", I would respond:

1) It may also help you. People will look at the code. If they notice bugs,
they may tell you. They may add new capabilities. People may support
themselves -- I know if I encounter a problem with a piece of software and I
have the source, I'll try to track it down myself. It's easier for me.

2) It may help your customers. If they have a problem, they may be able to
fix it themselves. (Yes, many people are capable of making a new build and
burning it onto an embedded device.) If they need additional features, they
may add them. They may be more willing to buy your products if they know
they can support it themselves should you go away and if they can see the
quality of your code.

3) It may help the community at large. You never know when someone will have
a problem similar to one you have already solved.

4) It may not help your competitors. If they're committed to closed source,
they probably  won't do much with your software. Especially when we're
talking about drivers, this argument seems particularly weak.

DS


