Return-Path: <linux-kernel-owner+w=401wt.eu-S1751228AbZKJKcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbZKJKcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZKJKcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:32:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40273 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811AbZKJKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:32:01 -0500
Date: Tue, 10 Nov 2009 10:32:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       KMoorman@transy.edu, w.sang@pengutronix.de,
       ken_kawasaki@spring.nifty.jp, davem@davemloft.net,
       Andrew Morton <akpm@osdl.org>
Subject: Re: serial_cs: oxsemi quirk breaks resume
Message-ID: <20091110103259.6050db7e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091110075410.GA6157@ucw.cz>
References: <20091110075410.GA6157@ucw.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 08:54:11 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Quirk is applied on all cards with given manfid (is it that
> correct?). Unfortunately, that quirk breaks resume on zaurus with
> billionton bluetooth card inserted: c950ctrl is 0 and outb() faults.

So how does it end up as zero, do you have a race between insert/remove
somewhere ?

