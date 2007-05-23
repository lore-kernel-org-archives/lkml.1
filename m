Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXEWJuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXEWJuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXEWJtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:49:55 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51457 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXEWJty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:49:54 -0400
Date: Wed, 23 May 2007 18:48:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_platform: Disable prereset logic.
Message-ID: <20070523094858.GA30352@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070523064408.GA29593@linux-sh.org> <4653F62C.4070700@gmail.com> <20070523083026.GA29851@linux-sh.org> <46540981.9080603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46540981.9080603@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 11:29:37AM +0200, Tejun Heo wrote:
> Paul Mundt wrote:
> > On Wed, May 23, 2007 at 10:07:08AM +0200, Tejun Heo wrote:
> >> Paul Mundt wrote:
> >>> On a number of boards the current prereset logic seems to misbehave:
> >>>
> >>> scsi0 : pata_platform
> >>> ata1: PATA max PIO0 cmd 0xb06001f0 ctl 0xb06003f6 bmdma 0x00000000 irq 0
> >>> ata1: device not ready (errno=-19), forcing hardreset
> >>> ata1: BUG: prereset() requested invalid reset type
> >>>
> >>> This triggers when there is no card inserted in the slot.
> >>>
> > ata_wait_ready() works fine, it reports 0xff immediately (and this is
> > what I would expect when there is no card inserted).
> 
> Does the attached patch fix your problem?
> 
Yes, that works fine, thanks.
