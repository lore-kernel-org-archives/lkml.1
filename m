Return-Path: <linux-kernel-owner+w=401wt.eu-S934229AbYBMRyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229AbYBMRyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762565AbYBMRyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:54:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYBMRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:54:32 -0500
Date: Wed, 13 Feb 2008 15:53:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Ricardo Cerqueira <ricardo@cerqueira.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
Message-ID: <20080213155352.06d966cd@gaivota>
In-Reply-To: <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Tue, 12 Feb 2008, Mauro Carvalho Chehab wrote:
> >    - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;
> 
> So you decided to just commit this one with the race condition anyway?

The version with problems is the one dated by Jan, 16:
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-January/006119.html

As Ricardo stated on Feb, 5, he fixed the lock issues, that were present on
your first revision:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006292.html

I've pushed the reviewed version at the same day, for testing, at the
development environment:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006326.html

Nobody pointed any newer issues on the reviewed version, since then.

If you still see any issues, please send us a patch fixing it.

Mauro
