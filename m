Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbYBZXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbYBZXfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYBZXfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:35:32 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4792 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYBZXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:35:30 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <khc@pm.waw.pl>
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: RE: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Date: Tue, 26 Feb 2008 15:35:21 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEBIKLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <m3ir0bcnvo.fsf@maximus.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 15:36:53 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 26 Feb 2008 15:36:55 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> "David Schwartz" <davids@webmaster.com> writes:

> > The agreement made when the feature was added was that
> > EXPORT_GPL was not a
> > license enforcement mechanism but was an indication that
> > someone believed
> > that any use of the symbol was possible only a derivative work
> > that would
> > need to be distributed under the GPL.

> But the above gives us nothing.
> *If* any use of non-GPL symbols only by a binary module was ok then it
> would make sense.

I don't buy your argument. It's essentially saying that a scheme that can't
detect all possible problems is useless, even if it can detect some
problems.

> >> Actually I think the _GPL exports are really harmful - somebody
> >> distributing a binary module may claim he/she doesn't violate the GPL
> >> because the module uses only non-GPL exports.

> > Anyone can argue anything. That would be an obviously stupid argument.
> > Perhaps clearer documentation might be helpful, but the GPL speaks for
> > itself.

> Not sure if the court would share this opinion.
> Defendant: my module doesn't use any GPL-only export!
> Plaintiff: but using XXX normal symbol is a violation too!
> D: so why have you created that _GPL thing exactly?

This is akin to "Maybe I was swerving, but I must have been driving safely
because I wasn't drunk". Everyone who drives drunk isn't safe, but it
doesn't follow that you're safe just because you're not drunk.

This is an obviously-wrong argument, and the fact that someone can make it
isn't interesting. People can make all kinds of obviously-wrong arguments.

Maybe this is a documentation issue.

The GPL exports mark symbols that someone felt could not be used in a
non-derivative work, "intimate details" if you like. But whether or not
something is a derivative work is a pure question of copyright law and the
nature of what was taken. (One could make an argument that not marking
symbols acts as some kind of estoppel against later arguing that just
minimally using that symbol can't make your work a derivative. It's possible
a judge might by that argument, but if so, how is that unreasonable?)

> Additionally:
> D: top of the COPYING file explicity states binary modules are ok.

I don't think anybody really knows what legal effect that will have. I can
speculate, but I don't know that my speculations are particularly
interesting. If anyone wants my analysis of that, feel free to email me
off-list.

> This is of course fine if we consider normal use of non-GPL-only
> symbols ok.

It's fine either way. Whatever you feel about non-GPL-only symbols, there's
nothing wrong with marking some symbols that, in the opinion of their
copyright holders, cannot be used by non-derivative works. If this is what
the GPL symbol marking does (which is what was agreed to when it was added)
then there's no harm.

> > They serve as a warning and, as a practical matter, may make it
> > a bit more
> > difficult to violate the license.

> Technically only.

All you can do in code is implement technical things. You cannot enforce or
implement the license because the GPL prohibits that.

> I have to agree with Alan that the list of non-GPL modules only is
> quite tiny nowadays. Madwifi is in terminal state, ATI is opening the
> docs and working on GPL driver, modem drivers are mostly thing of
> the past, NVidias will probably be supported by the open source driver
> soon even if they don't open their code.
>
> Embedded devices have full Linux, not just modules.

If you're arguing that GPL symbol export has outlived its usefulness, that
might be true. I don't really have an opinion one way or the other.

DS


