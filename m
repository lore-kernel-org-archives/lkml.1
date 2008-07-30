Return-Path: <linux-kernel-owner+w=401wt.eu-S1762526AbYG3P1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526AbYG3P1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYG3P1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:27:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39206 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753800AbYG3P1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:27:09 -0400
Date: Wed, 30 Jul 2008 11:27:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Matthew Frost <artusemrys@yahoo.com>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Matt Frost <artusemrys@sbcglobal.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
In-Reply-To: <1217429722.3335.3.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0807301124280.2584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, James Bottomley wrote:

> On Wed, 2008-07-30 at 10:17 -0400, Alan Stern wrote:
> > On Tue, 29 Jul 2008, Matthew Dharm wrote:
> > 
> > > Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
> > > just become a sysfs parameter which defaults to the 'ignore' state...
> > 
> > We have to be careful; there definitely are devices out there which 
> > need to use the Residue.
> 
> This is sort of a tradeoff ... there was one complaint I saw where a
> device turned read only without the fix idenitifed in this report.
> Devices broken by the fix are definitely crawling out of the woodwork
> now.  Either this patch needs to be reverted or a new fix needs to be
> applied soon (and to stable).

I would expect this patch:

	http://marc.info/?l=linux-usb&m=121734710306509&w=2

to take care of most of the problems.  But it hasn't yet been merged,
and it can't go into -stable until then.

Alan Stern

