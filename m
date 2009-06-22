Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZFVM4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZFVM4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZFVM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:56:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:57049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZFVM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:56:27 -0400
Subject: Re:
From: David Woodhouse <dwmw2@infradead.org>
To: Kay Sievers <kay.sievers@suse.de>
Cc: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1245527124.30962.14.camel@yio.site>
References: <1245527124.30962.14.camel@yio.site>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 13:56:23 +0100
Message-Id: <1245675383.25547.50.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 21:45 +0200, Kay Sievers wrote:
> The final piece of the driver core name limit. We are about to remove
> BUS_ID_SIZE.
> 
> Some patches may still be in your queue. Just to make sure, we will
> finish our task this time: David, David, James, Takashi, can you please
> give an update, or take care of removing the last instances, or let me
> know if you want a patch, or let us know, if we should just change it to
> "20".

I have this queued for 2.6.31 but have been on jury duty for the last 2
weeks so I'm hoping to get the pull request to Linus today now that I'm
free.

Was very unimpressed with the first version of the patch I saw, which
would have given me a potential buffer overflow if I'd just hard-coded
the buffer size AFAICT.

http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=81933046

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

