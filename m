Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXICCBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXICCBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXICCBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:01:31 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2191 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXICCB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:01:29 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <espie@nerim.net>, <linux-kernel@vger.kernel.org>
Subject: RE: GPL weasels and the atheros stink
Date: Sun, 2 Sep 2007 19:01:17 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMECFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070902140306.GA27317@lain.home>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:04 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 02 Sep 2007 19:02:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Letting aside the legality of that change, why would such a change
> be needed ? The licensing is perfectly clear: the file is available
> under the ISC licence, OR the GPL licence.  This doesn't cause any
> problem for the linux kernel. The ISC licence is perfectly compatible
> with the GPL (note to GPL trolls: this new licence does not have any
> advertizing clause, which was the ONLY issue with the old licence). And
> heck, they can use the code under the GPL licence. There is no
> incompatibility
> in there.

Your entire argument is based on the false assumption that these licenses
are compatible. They are not. You cannot put code that was offered under the
GPLv2 into code that is licensed under the dual license and distribute the
result.

> The only possible issue is related to paranoia: if this file stays
> dual-licenced, some of its code may escape from the GPL shrine, and
> become available to the cuddly BSD people... but since their licence
> doesn't protect anything, it could used by the Evil Empire of Microsoft,
> or SCO, or whoever is the villain of the month.

That's not the problem. The problem is that if the file stays dual-licensed,
everyone working on that file in the Linux kernel will have to be careful
not to put any GPLv2-only code into it. That's just untenable. Any
consistent license is better than different files being under different
licenses such that you can't cut and paste code between files.

> Let's extend the story a wee little bit. It seems that these days, some
> parts of the opensource community have gotten confident enough that they
> do not need the other part. We all know the situation is already fairly
> disymetric. The GPL is less free than the ISC licence for instance (for
> some definition of free), and practically, this makes it impossible to
> add GPL code to an ISC project without putting the project under the Aegis
> of the GPL licence. The reciprocal relationship does NOT hold. As you can
> see in various places, it is quite possible to put BSD code inside a GPL
> project without any issue (the FSF libiberty is a nice proof of that. And
> heck, the glibc as well... Read carefully past the COPYING file, you'll
> find numerous instances of BSD-like licences).

If you embed protectable elements from GPLv2-only code into any of those
files, they are no longer dual-licensed. You wind up creating traps and
complexity that makes the code much harder to maintain.

> So, now, it's down to dirty fighting. Absorbing and `relicensing' and
> evolving code.  Have you all been bitten my RMS paranoia (that leads to
> this `interesting GPLv3) ? Do you intend to keep grabbing BSD code and
> putting it exclusively under the GPL ?

It is just impractical to maintain code in the Linux tree under any other
license. See some of my other posts where I discuss the nightmare of trying
to add new hooks to every filesystem if different filesystems are under
different licenses and so you can't cut/paste the implementation from one
file to another.

> Do you really think he's going to keep his work under a
> dual-licence, seeing
> how a bunch of rabid linux zealots are all but intent on stealing his code
> whenever they can.
>
> Nice going, GPL fan-boys...

A dual-license is a compromise. One of the downsides is that you may force
large projects that are under one license or the other to fork the code. If
that bothers you, don't dual license.

DS


