Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZFARqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZFARqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZFARqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:46:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52135 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754295AbZFARqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:46:18 -0400
Date: Mon, 1 Jun 2009 18:46:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601184608.6379440c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601171119.GA13970@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you are on the command line then SIGINT/SIGQUIT would be the obvious
> > ones for this ?
> 
> Not sure I understand. Do you mean we should treat the tty signals
> specially ?

Yes

> Personally, I don't think we should. If we decide that only SIGKILL
> interrupts the coredumping, then I think ^C should not interrupt.

Wait until you have a remote session over ssh that core dumps a 2GB core.
Then you'll understand why being able to ^C or ^\ it is useful.

Alan
