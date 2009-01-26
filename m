Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZAZVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZAZVlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZAZVlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:41:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbZAZVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:41:36 -0500
Date: Mon, 26 Jan 2009 13:40:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: alan@lxorguk.ukuu.org.uk, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [tty bug] kernel BUG at drivers/char/tty_ldisc.c:359!
Message-Id: <20090126134047.11ad6134.akpm@linux-foundation.org>
In-Reply-To: <200901191727.48812.rjw@sisk.pl>
References: <20090113121039.GA22155@elte.hu>
	<20090113122338.13a155a0@lxorguk.ukuu.org.uk>
	<200901191727.48812.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 17:27:48 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 13 January 2009, Alan Cox wrote:
> > On Tue, 13 Jan 2009 13:10:39 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > FYI, -tip testing found a new warning in drivers/char/tty_ldisc.c:
> > 
> > Thanks - yes there is a real bug that is exposed by the BKL drop if you
> > manage to hit the flush ioctl as the ldisc changes 
> > 
> > Change the 
> > 	ld = tty_ldisc_ref(tty)
> > 
> > to
> > 	ld = tty_ldisc_ref_wait(tty);
> 
> Did this change go to Linus by chance?
> 

I cannot locate any such fix.
