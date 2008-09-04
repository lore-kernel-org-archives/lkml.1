Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYIDSih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYIDSih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYIDShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:37:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44985 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757153AbYIDShW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:37:22 -0400
Date: Thu, 4 Sep 2008 19:36:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ivaylo@bglans.net
Cc: linux-kernel@vger.kernel.org, w@1wt.eu
Subject: Re: Marvel IDE 88SE6101 2.4.XX support
Message-ID: <20080904193625.652bf013@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
	<Pine.LNX.4.64.0809042115350.11281@mail.bglans.net>
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

On Thu, 4 Sep 2008 21:26:12 +0300 (EEST)
ivaylo@bglans.net wrote:

> 
> Another one small patch to support Marvel IDE 88SE6101 controler. I have 
> one on Intel DG33BU motherboard. It is detect as
> 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port 
> PATA133 interface (rev b2)

Its a pretty generic device - see drivers/ata/pata_marvell.c so IDE
generic will probably do roughly the right things. The pata_marvell
driver documents how to do cable detect, which you may want to add and
make it its own driver.

Alan
