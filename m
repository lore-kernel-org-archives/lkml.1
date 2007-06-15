Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbXFOU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbXFOU4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXFOU4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:56:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55671 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbXFOU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:56:06 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: holzheu@linux.vnet.ibm.com, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Reply-To: Gerrit Huizenga <gh@us.ibm.com>
From: Gerrit Huizenga <gh@us.ibm.com>
Subject: Re: [RFC/PATCH] Documentation of kernel messages 
In-reply-to: Your message of Fri, 15 Jun 2007 11:51:51 PDT.
             <4672DFC7.20801@oracle.com> 
Date: Fri, 15 Jun 2007 12:27:25 -0700
Message-Id: <E1HzHSA-0006Dg-3a@w-gerrit.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Jun 2007 11:51:51 PDT, Randy Dunlap wrote:
> 
> For those of us who have not been in on these meetings, I think that
> some serious justifications are needed.  The last paragraph began to
> go in that direction, but it needs to be more detailed and convincing.
> And "for debugging" doesn't cut it IMO.
> 
> -- 
> ~Randy

Fair point, Randy.

This came up this time because people in Japan supporting Linux customers
are not always familiar with Linux kernel internals and thus debugging
problems based on a terse, English language message is just painful.  Also,
any given message doesn't really provide any input about what *really*
failed, what should be done about it, how to correct this issue, or what
parts to pull out of your machine and replace with properly working parts.

So, the Message Pedia is basically a Japanese language wiki today where
people doing support can annotate the messages with real life experience on
what to *do* about the error.

Part of the problem is that the error messages when extracted don't
stand alone and don't easily allow tracing back to the real source.  When
the problem is handed from the second line support folks deeper into the
support or development organization, the message has to be found in the
source tree in some non-ambiguous fashion.

The other problem that comes up in other, non-English locales is that
debugging your Linux box when you are a non-native English speaker is
just plain impossible.  Providing a means for getting localized kernel
messages allows more end users to at least reasonably debug their own
machine.  Most every user level project today allows localization directly
but the kernel has never had any reasonable mechanism for localisation.

Now, the proposal here doesn't make the kernel "as good as" user level
application, but it would at least provide a searchable key to help
people get localized guidance on problems.

I'm sure there are other benefits that most can see based on just simple
debuggability.  But the Japanese goal is really to construct a database
of debugging info & context based on their experiences.

And, I'm sure that others can speak for themselves.  I'm mostly playing
scribe on this one - we abandoned our error and event subsystem work years
ago, even though this was one of the biggest weaknesses we saw in customer
support 3-5 years ago, simply because our changes were still viewed as
too invasive for mainline kernel.  These proposed changes help a lot, while
remaining almost completely invisible to most developers.

gerrit
