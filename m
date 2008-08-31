Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYHaXsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYHaXsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 19:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYHaXr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 19:47:56 -0400
Received: from vs02.svr02.mucip.net ([83.170.6.69]:56652 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHaXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 19:47:56 -0400
Date: Mon, 1 Sep 2008 01:47:52 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc xen pvops regression?
Message-ID: <20080831234752.GA16168@pest>
References: <20080831171848.GA11653@pest> <48BB174C.4080900@citrix.com> <48BB22C3.4020300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BB22C3.4020300@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 04:01:23PM -0700, Jeremy Fitzhardinge wrote:

> >> I've been a happy user of vanilla 2.6.26 with pvops in my Xen domU for
> >> a couple of months. I wanted to test 2.6.27-rc (-rc3 a couple of weeks
> >> ago, -rc5 just now) to verify another issue and ran into the following
> >> error
> > Thanks Bernhard - I'm able to reproduce it with your config.
> Is this the crash with the UP config?

Ah, good hint, enabling SMP in the domU indeed fixes the problem.

> > (XEN) mm.c:2249:d168 Mfn 24384 not pinned
> Bit hard to know what this means without knowing what mfn 24384 is.

FWIW, I don't have any message in my "xm dmesg".

Bernhard
