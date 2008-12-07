Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYLGSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYLGSgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYLGSgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:36:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39240 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754104AbYLGSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:36:38 -0500
Date: Sun, 7 Dec 2008 18:36:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: LibATA error
Message-ID: <20081207183647.3ba03750@lxorguk.ukuu.org.uk>
In-Reply-To: <20081207153757.GA5761@ics.muni.cz>
References: <20081206185252.GA4323@ics.muni.cz>
	<493AE09F.5010108@shaw.ca>
	<20081207153757.GA5761@ics.muni.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It could be.. it means the drive sent the controller a SATA FIS (frame  
> > information structure) it didn't recognize.
> 
> hm, if I disable NCQ, I do not get these errors. Maybe OCZ SSD disks should be
> blacklisted for NCQ?

They shouldn't be claiming they can do NCQ if so. Can you dump out the
identify data in full (with hdparm) and if possible (or if someone else
with one can comment..) find out whether the same occurs with different
controller types.

Alan
