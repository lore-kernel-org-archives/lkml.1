Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbZFXOUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbZFXOUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZFXOUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:20:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41719 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbZFXOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:20:46 -0400
Subject: Re: BUS_ID_SIZE is going away
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <1245852555.25547.5745.camel@macbook.infradead.org>
References: <1245527124.30962.14.camel@yio.site>
	 <1245675383.25547.50.camel@macbook.infradead.org>
	 <1245832038.2483.3.camel@yio.site>
	 <1245842095.25547.5380.camel@macbook.infradead.org>
	 <1245848356.32629.14.camel@pc1117.cambridge.arm.com>
	 <1245852555.25547.5745.camel@macbook.infradead.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 24 Jun 2009 15:20:13 +0100
Message-Id: <1245853213.32629.45.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2009 14:20:14.0382 (UTC) FILETIME=[E4196CE0:01C9F4D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:09 +0100, David Woodhouse wrote:
> On Wed, 2009-06-24 at 13:59 +0100, Catalin Marinas wrote:
> > I gave physmap a quick try on RealView boards and it seems to work fine
> > with the patch below. The only difference is the AFS partition parsing
> > probes string, though this is no longer used on ARM Ltd platforms (some
> > old ones still use it).
> 
> Perhaps we should add the list of partition types to the
> physmap_flash_data?

I think this would make sense.

-- 
Catalin

