Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYAVWmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYAVWmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYAVWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:42:36 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49581 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYAVWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:42:34 -0500
Date: Tue, 22 Jan 2008 22:41:11 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
In-Reply-To: <20080122221214.1c825949@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0801222238140.30816@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
 <1201022985.3210.24.camel@localhost.localdomain> <20080122221214.1c825949@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Alan Cox wrote:
> > However, I'd like to see if we can track the problem through the SG_IO
> > direct path ... how many adjacent page bytes are corrupt?  Just a few or
> > a large number (I'm wondering if it's an off by one or off by alignment
> > type bug)?

We moved away from that concern ....

> Which ATA controller is involved - in theory ATA DMA is byte aligned safe
> (or dword anyway) in practice I don't know if we've ever tested the non
> 512 byte aligned case historically for ATA just ATAPI ?

.... but if it's still relevant, this was with ata_piix.

Hugh
