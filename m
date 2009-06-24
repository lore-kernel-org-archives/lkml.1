Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZFXOJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZFXOJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZFXOJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:09:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:52457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZFXOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:09:30 -0400
Subject: Re: BUS_ID_SIZE is going away
From: David Woodhouse <dwmw2@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <1245848356.32629.14.camel@pc1117.cambridge.arm.com>
References: <1245527124.30962.14.camel@yio.site>
	 <1245675383.25547.50.camel@macbook.infradead.org>
	 <1245832038.2483.3.camel@yio.site>
	 <1245842095.25547.5380.camel@macbook.infradead.org>
	 <1245848356.32629.14.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 15:09:14 +0100
Message-Id: <1245852555.25547.5745.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 13:59 +0100, Catalin Marinas wrote:
> I gave physmap a quick try on RealView boards and it seems to work fine
> with the patch below. The only difference is the AFS partition parsing
> probes string, though this is no longer used on ARM Ltd platforms (some
> old ones still use it).

Perhaps we should add the list of partition types to the
physmap_flash_data?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

