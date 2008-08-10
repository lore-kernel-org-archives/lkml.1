Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYHJMNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYHJMNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYHJMN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:13:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41071 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285AbYHJMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:13:28 -0400
Date: Sun, 10 Aug 2008 12:54:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Query: should 'Marvell SATA support' depend on PCI?
Message-ID: <20080810125432.3504a7fa@lxorguk.ukuu.org.uk>
In-Reply-To: <200808101408.11393.rjw@sisk.pl>
References: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
	<200808101408.11393.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > doesn't have 'depends on PCI && EXPERIMENTAL' like other drivers around 
> > it, this is okay or should it also depend on PCI?
> 
> Well, I think so.  It obviously depends on PCI.

Obviously ? Try looking a bit harder

/**
 *      mv_platform_probe - handle a positive probe of an soc Marvell
 *      host
 *      @pdev: platform device found
 *
 *      LOCKING:
 *      Inherited from caller.
 */
static int mv_platform_probe(struct platform_device *pdev)


Alan
