Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXF3HwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXF3HwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXF3HwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:52:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbXF3HwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:52:12 -0400
Date: Sat, 30 Jun 2007 00:52:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Davide Libenzi <davidel@xmailserver.org>, Hugh Dickins <hugh@veritas.com>,
       Ulrich Drepper <drepper@gmail.com>, blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Message-Id: <20070630005200.27d71cc4.akpm@linux-foundation.org>
In-Reply-To: <1182982309.2737.9.camel@entropy>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	<a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
	<Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
	<a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
	<Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
	<a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
	<Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com>
	<Pine.LNX.4.64.0706271921280.29060@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0706271135560.32731@alien.or.mcafeemobile.com>
	<1182982309.2737.9.camel@entropy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 15:11:49 -0700 Nicholas Miell <nmiell@comcast.net> wrote:

> I don't think the security issues with this will ever make it
> worthwhile.

eh, security issues are a corner case.

The vast majority of Linux machines are used by a single user who has admin
access anyway.  This includes all embedded, all consumer and most laptop
and desktop.

So a reasonable way of getting the benefit of this change into most
people's hands is to forget about the uid/euid issues altogether and just
have a big fat knob which enables this feature, system-wide.  (Radical,
huh.   But then, I liked single user linux.)

A significant problem I see with any such approach is that it yet again
weakens the overall testing and QA effort: libc and the kernel now need to
be tested with and without this feature, and it's yet another question to
be asked of the bug reporters.

(But please take none of this as endorsement.  For some reason the whole
thing gives me the creepies).

