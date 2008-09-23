Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYIWFAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYIWFAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYIWFAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:00:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYIWE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:59:59 -0400
Date: Tue, 23 Sep 2008 07:04:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Martin Bligh <mbligh@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923050447.GG25711@one.firstfloor.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <878wtjr0y1.fsf@basil.nowhere.org> <33307c790809222047h7eaae674r8dd165ab8744910a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809222047h7eaae674r8dd165ab8744910a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think we can remove relayfs before adding this and switching over
> the users though (possibly it could all be done at the same time, but messy)

It's only two in tree users (+ systemtap) so shouldn't be a big hazzle.
And they're all tracers so presumably they all pass time stamps. But please
don't add a multitude of new methods to do this.

BTW I've been using something like that since early 2000. It was called
ktrace and was based on a old SGI patch.

-Andi

-- 
ak@linux.intel.com
