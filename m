Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAVWO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAVWO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYAVWOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:14:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58276 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYAVWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:14:47 -0500
Date: Tue, 22 Jan 2008 22:12:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Message-ID: <20080122221214.1c825949@lxorguk.ukuu.org.uk>
In-Reply-To: <1201022985.3210.24.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	<1201022985.3210.24.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I'd like to see if we can track the problem through the SG_IO
> direct path ... how many adjacent page bytes are corrupt?  Just a few or
> a large number (I'm wondering if it's an off by one or off by alignment
> type bug)?

Which ATA controller is involved - in theory ATA DMA is byte aligned safe
(or dword anyway) in practice I don't know if we've ever tested the non
512 byte aligned case historically for ATA just ATAPI ?

Alan
