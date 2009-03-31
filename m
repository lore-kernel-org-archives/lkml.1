Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZCaLzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZCaLzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZCaLzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:55:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34234 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752317AbZCaLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:55:39 -0400
Date: Tue, 31 Mar 2009 12:28:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: petkovbb@gmail.com
Cc: petkovbb@googlemail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michael Roth <mroth@nessie.de>, linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
 workaround
Message-ID: <20090331122820.167d52e5@the-village.bc.nu>
In-Reply-To: <20090331074508.GA16403@liondog.tnic>
References: <49CFCB2A.4020505@nessie.de>
	<49CFEA24.10700@nessie.de>
	<20090330072713.GA13776@liondog.tnic>
	<200903302228.54601.bzolnier@gmail.com>
	<20090331074508.GA16403@liondog.tnic>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> take it ok. Also, if I remember correctly, the original ide-cd behavior
> was to issue the command and _then_ start DMA so we're back to that. I
> guess now we should be concerned whether the other ATAPI devices can
> handle the reverse situation where you first issue a command and _then_
> start DMA.. Hmm...

Most devices don't care but you do need to follow the exact ATAPI spec.
If you search way back through the archives you'll find long discussions
on this during either 2.4 or 2.2 when HP hit problems caused by us
turning DMA on too early.
