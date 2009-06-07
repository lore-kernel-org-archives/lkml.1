Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZFGPKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZFGPKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZFGPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:10:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41757 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753154AbZFGPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:10:28 -0400
Date: Sun, 7 Jun 2009 16:11:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
Message-ID: <20090607161133.699c6828@lxorguk.ukuu.org.uk>
In-Reply-To: <200906071703.43285.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	<200906071632.30914.bzolnier@gmail.com>
	<20090607154048.07a7fb65@lxorguk.ukuu.org.uk>
	<200906071703.43285.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This isn't about technical merits - it is about *risk*. You don't submit
> 
> fs/partitions/check.c change doesn't influence anything other that behavior
> of ide-gd driver and has been ACK-ed by Al Viro.

What part of "risk" don't you understand ? Any change to core code paths
is a risk, submitting it just before 2.6.30 is plain stupid.

> > patches to core code to add new features just before the final release.
> 
> This is not a feature but really a bug fix (requested by you along other
> people in the past).

Its not an urgent this release doom-disaster fix - its a run of the mill
feature improvement that fixes up a long term issue and wants testing in
quantity before merging and nicely integrating so other storage people
are happy with it.
