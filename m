Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZASQ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZASQ2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZASQ2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:28:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZASQ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:28:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [tty bug] kernel BUG at drivers/char/tty_ldisc.c:359!
Date: Mon, 19 Jan 2009 17:27:48 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20090113121039.GA22155@elte.hu> <20090113122338.13a155a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113122338.13a155a0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191727.48812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Alan Cox wrote:
> On Tue, 13 Jan 2009 13:10:39 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > FYI, -tip testing found a new warning in drivers/char/tty_ldisc.c:
> 
> Thanks - yes there is a real bug that is exposed by the BKL drop if you
> manage to hit the flush ioctl as the ldisc changes 
> 
> Change the 
> 	ld = tty_ldisc_ref(tty)
> 
> to
> 	ld = tty_ldisc_ref_wait(tty);

Did this change go to Linus by chance?

Rafael
