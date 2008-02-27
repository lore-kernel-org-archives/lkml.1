Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbYB0A3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbYB0A3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbYB0A3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:29:15 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4810 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbYB0A3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:29:14 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <khc@pm.waw.pl>
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: RE: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Date: Tue, 26 Feb 2008 16:28:43 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOECAKLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <m3wsorb6wq.fsf@maximus.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 16:30:14 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 16:30:15 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> "David Schwartz" <davids@webmaster.com> writes:

> > This is an obviously-wrong argument,

> Even if it's proven wrong in the end, the defendant may at least be
> found acting in a good faith.

If they were in fact acting in good faith, they should be found to have been
acting in good faith. If you think this reasonably might result in
confusion, the solution is better documentation.

> > All you can do in code is implement technical things.

> The GPL itself is the weapon, not the technical measures which can be
> legally trivially disabled (even if the modules are illegal).

Right.

> > You cannot enforce or
> > implement the license because the GPL prohibits that.

> Not sure what do you mean. I was under impression that a copyright
> holder can enforce GPL :-)

I mean you can't enforce or implement the license in code because the GPL
specifically permits modification without exclusion. Someone cannot use the
GPL to force you to use code you do not wish to use. The GPL does not
contain any technical enforcement mechanism and would not permit one because
it would be a "further restriction" (it's a restriction, it's not in the
GPL, so it's further).

Perhaps some kind of technical rule that didn't prohibit anything the GPL
allowed might be a legitimate license enforcement scheme, not restricting
anything "further". That's a stretch, but the GPL symbol tagging doesn't
apply since it prohibits non-GPL modules from using those symbols even if
they are not distibuted. This is not a restriction found in the GPL, so it's
a "further restriction". (Which is fine. Not being able to remove any file
as 'root' is a restriction not found in the GPL too. The point is, these are
technical restrictions, not license enforcement mechanisms.)

DS


