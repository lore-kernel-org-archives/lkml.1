Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXGJSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXGJSzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXGJSzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:55:08 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:42351 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbXGJSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:55:05 -0400
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Deepak Saxena <dsaxena@plexity.net>, Dan Faerch <dan@hacker.dk>,
       Benjamin LaHaise <bcrl@kvack.org>
In-Reply-To: <20070710112458.e9dbb55e.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <4693C4F8.40903@garzik.org>
	 <20070710112458.e9dbb55e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 14:55:02 -0400
Message-Id: <1184093702.3401.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 11:24 -0700, Andrew Morton wrote:
> > > ata-ahci-alpm-store-interrupt-value.patch
> > > ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
> > > ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
> > > ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
> > > 
> > >  These appear to need some work.
> > 
> > seemed mostly OK to me.  what comments did I miss?
> 
> Oh, I thought these were the patches which affected scsi and which James
> had issues with.  I guess I got confused.

Well ... my concern was really how to make them more generic ... ahci
isn't the only controller that can do phy power management, and it also
seemed to me that the most generic entity for power management was the
transport rather than the SCSI mid-layer, but that debate is still
ongoing.

James


