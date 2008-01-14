Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYANWb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYANWb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbYANWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:31:10 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:59983 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbYANWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:31:08 -0500
Date: Mon, 14 Jan 2008 17:30:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <200801142316.39330.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.58.0801141730150.3109@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>
 <200801142316.39330.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jan 2008, Mariusz Kozlowski wrote:

> Hello,
>
> > We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
> > downloaded from the location:
> >
> >   http://rt.et.redhat.com/download/
>
> Compiles fine but I run into another problem. On startup kernel oopses
> early and this 'oops' loops over and over again on the screen until you
> shut down the box. So I can't (easily) capture the output. I tried different
> boot_delay values but it seems that it doesn't work as intended. Seems that
> it delays only the first printk from oops, then the rest loops over the screen
> without delay - again it becomes unreadable. I used my usual config with a bunch
> of debug options enabled so that maybe is not real rt system case. Also tried to
> bisect it with quilt but that is hard. Lots of patches depends on another patches
> so bisection brakes things. I'll look into this tommorow and reply if I get
> anything substantial.
>
> I attached my config in case anybody wants to try to reproduce that.
>

Turn off LOCKDEP and see if you still have the same problems. This might
be fixed with Daniel's patch.

-- Steve

