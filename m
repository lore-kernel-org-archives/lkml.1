Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbYBZSVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbYBZSVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYBZSUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:20:54 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3245 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYBZSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:20:53 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <khc@pm.waw.pl>
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: RE: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Date: Tue, 26 Feb 2008 10:19:42 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEONKKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <m3d4qj90zm.fsf@maximus.localdomain>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 10:21:14 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 10:21:15 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> "David Schwartz" <davids@webmaster.com> writes:

> > I don't know who told you that or why, but it's obvious nonsense,

> Correct.

> > Exports should be marked GPL if and only if they cannot be used
> > except in a derivative work. If it is possible to use them
> > without taking
> > sufficient protectable expression, they should not be marked GPL.

> This isn't very obvious to me.

It may not be obvious, but it is the design and purpose of marking exports
GPL.

> The licence doesn't talk about GPL or non-GPL exports. It doesn't
> restrict the use, only distribution of the software. One is free to
> remove _GPL from the code and distribute it anyway (except perhaps for
> some DMCA nonsense).

That's true. The DMCA doesn't prevent it, since marking symbols is *not* a
license enforcement mechanism.

> If a code is a derivative work it has to be distributed (use is not
> restricted) under GPL, EXPORT _GPL or not _GPL.

Of course.

> One may say _GPL is a strong indication that all users are
> automatically a derivative works, but it's only that - indication. It
> doesn't mean they are really derivative works and it doesn't mean a
> module not using any _GPL exports isn't a derivative.

Of course. (The only people who argue otherwise are the 'linking makes a
derivative work' idiots.)

> I think introducing these _GPL symbols was a mistake in the first place.

Perhaps, since people seem to be trying to refight the same battles again.

The agreement made when the feature was added was that EXPORT_GPL was not a
license enforcement mechanism but was an indication that someone believed
that any use of the symbol was possible only a derivative work that would
need to be distributed under the GPL.

> Actually I think the _GPL exports are really harmful - somebody
> distributing a binary module may claim he/she doesn't violate the GPL
> because the module uses only non-GPL exports.

Anyone can argue anything. That would be an obviously stupid argument.
Perhaps clearer documentation might be helpful, but the GPL speaks for
itself.

> OTOH GPL symbols give
> _us_ exactly nothing.

They serve as a warning and, as a practical matter, may make it a bit more
difficult to violate the license.

DS


