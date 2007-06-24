Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbXFXSAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbXFXSAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXFXSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:00:00 -0400
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:58248 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXFXR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:59:59 -0400
Date: Sun, 24 Jun 2007 12:59:57 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
Message-ID: <20070624125957.2e27820c@osprey.hogchain.net>
In-Reply-To: <467D0EB0.9030100@esuna.co.uk>
References: <467B12CA.5060405@esuna.co.uk>
	<467BE118.4090308@redhat.com>
	<467BE4F1.7040308@esuna.co.uk>
	<467D0EB0.9030100@esuna.co.uk>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:14:40 +0100
"Jay L. T. Cornwall" <jay@esuna.co.uk> wrote:


> The common factor here seems to be the buffer_head circular list
> leading to invalid pointers in bh->b_this_page.
> 
> I'm beginning to suspect the Attansic L1 Gigabit Etherner driver
> (marked as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these
> panics on disk-to-disk copies or SCP across the localhost interface.
> However, SCP from a server onto either of two different HDDs hits
> these oopses fairly quickly.

How much RAM is installed in your machine?  If it's 4GB or more, does
your problem go away if you boot with mem=3000M?

Jay
