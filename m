Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZBPX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZBPX43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZBPX4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:56:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45785 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZBPX4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:56:17 -0500
Message-ID: <4999FD1A.3080407@pobox.com>
Date: Mon, 16 Feb 2009 18:56:10 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] libata-sff: fix 32-bit PIO ATAPI regression
References: <200902152224.25144.sshtylyov@ru.mvista.com>
In-Reply-To: <200902152224.25144.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d (libata: Add 32bit PIO support)
> has caused all kinds of errors on the ATAPI devices, so it has been empirically
> proven that one shouldn't try to read/write an extra data word when a device is
> not expecting it already. "Don't do it then"; however, still use a chance to do
> 32-bit read/write one last time when there are exactly 3 trailing bytes.
> 
> Oh, and stop pointlessly swapping the bytes to and fro on big-endian machines
> by using io*_rep() accessors which shouldn't byte-swap.
> 
> This patch should fix the kernel.org bug #12609.
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Added the comments and signoff.
> The patch is against the recent Linus' tree.
> It's a hopefully better replacement for Hugh Dickins most recent patch
> (http://marc.info/?l=linux-ide&m=123352294619281)...

applied, much appreciated!


