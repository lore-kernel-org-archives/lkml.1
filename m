Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbYBWU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbYBWU41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYBWU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:56:17 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55409 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbYBWU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:56:16 -0500
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
References: <1203779614.3139.4.camel@localhost.localdomain>
	 <47C08134.2030205@garzik.org>
	 <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 14:56:12 -0600
Message-Id: <1203800172.3139.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 12:31 -0800, Linus Torvalds wrote:
> 
> On Sat, 23 Feb 2008, Jeff Garzik wrote:
> > 
> > I know I am probably shooting myself in the foot here, since I am the original
> > author of mvsas, but...
> > 
> > Should we be adding new drivers during -rc?
> 
> I'm personally of the opinion that a new driver that doesn't add anything 
> but itself (ie no infrastructure changes etc) is fine. I'd rather have a 
> new, rough driver that might work, than no driver at all, and it's not 
> like it can cause a regression if you don't enable it.

That is the case for this one.  The two patches only touch the mvsas.c
file (and Makefile and Kconfig to build it, of course).

James


