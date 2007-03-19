Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbXCSTJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbXCSTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXCSTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:09:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXCSTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:09:16 -0400
Date: Mon, 19 Mar 2007 12:08:07 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: jg@laptop.org
Cc: zaitcev@redhat.com, linux-kernel@vger.kernel.org
Subject: BSOD (was: [2/6] 2.6.21-rc2: known regressions)
Message-Id: <20070319120807.af36ef5d.zaitcev@redhat.com>
In-Reply-To: <1174236045.6832.9.camel@localhost>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015034.GG3441@stusta.de>
	<20070308123143.GF5149@mellanox.co.il>
	<Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
	<20070308192554.GA2999@elte.hu>
	<20070308230705.GA4611@elte.hu>
	<Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>
	<20070309111957.GA3928@elf.ucw.cz>
	<20070318160707.GC12673@elte.hu>
	<1174236045.6832.9.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 12:40:45 -0400, Jim Gettys <jg@laptop.org> wrote:

> Also more seriously, a somewhat hybrid approach is in order for mode
> setting: simple mode setting isn't much code and is required for sane
> behavior on crash (it is nice to get oopses onto a screen); but the full
> blown mode setting/configuration problem is so large that on some
> hardware, it is likely left best left to a helper process (not the X
> server).

Jim, I doubt that a mode switch on oops is a good idea. Maybe I'm unlucky,
but in my experience, it often is the case that systems fail to switch
to text mode for shutdown. What is amazing, the very same systems switch
to text mode on <Alt>F1 just fine, and then back to <Alt>F7!
I would hazard a guess that this happens because nobody cares
about shutdown modes to fix them. But then the same is true for
crashes.

I understand that you have your own experience, but thought to note
this all the same.

>From the constructive angle, I think that a crash should render into
existing mode, into the currently mapped frame buffer. This is the
only way how it can be made to work reliably.

Yours,
-- Pete
