Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZJSWYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZJSWYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZJSWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:24:38 -0400
Received: from mga05.intel.com ([192.55.52.89]:12641 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755536AbZJSWYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,587,1249282800"; 
   d="scan'208";a="738132157"
Date: Tue, 20 Oct 2009 00:26:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mike Frysinger <vapier@gentoo.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Staticise __adp5520_ack_bits()
Message-ID: <20091019222636.GA22300@sortiz.org>
References: <1255963582-6796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <8A42379416420646B9BFAC9682273B6D0E695B8F@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E695B8F@limkexm3.ad.analog.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 04:09:07PM +0100, Hennerich, Michael wrote:
> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> >The function is not exported as the __ indicates. __
> >
> >Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> 
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Thanks guys, applied to my for-next branch.

Cheers,
Samuel.
 
> 
> >---
> > drivers/mfd/adp5520.c |    3 ++-
> > 1 files changed, 2 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> >index 401a9b6..b266447 100644
> >--- a/drivers/mfd/adp5520.c
> >+++ b/drivers/mfd/adp5520.c
> >@@ -66,7 +66,8 @@ static int __adp5520_write(struct i2c_client *client,
> > 	return 0;
> > }
> >
> >-int __adp5520_ack_bits(struct i2c_client *client, int reg, uint8_t
> bit_mask)
> >+static int __adp5520_ack_bits(struct i2c_client *client, int reg,
> >+			      uint8_t bit_mask)
> > {
> > 	struct adp5520_chip *chip = i2c_get_clientdata(client);
> > 	uint8_t reg_val;
> >--
> >1.6.5
> 
> -Michael

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
