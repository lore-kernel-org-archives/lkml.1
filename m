Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbZLPSIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbZLPSIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbZLPSIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:08:53 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:46776 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZLPSIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:08:51 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 13:08:51 EST
Date: Wed, 16 Dec 2009 19:08:49 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ep93xx_eth.c: general cleanup
Message-ID: <20091216180849.GM1819@mail.wantstofly.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECE7@mi8nycmail19.Mi8.com> <20091216180132.GL1819@mail.wantstofly.org> <BD79186B4FD85F4B8E60E381CAEE19090200ED01@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ED01@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 01:06:10PM -0500, H Hartley Sweeten wrote:

> >> General cleanup of the ep93xx_eth driver.
> >
> > Apart from keeping DRV_MODULE_NAME and DRV_MODULE_VERSION, I have
> > no strong opinion about this one way or the other.  So I guess that
> > means ACK.
> 
> I will add back the DRV_MODULE_NAME and DRV_MODULE_VERSION and repost.
> 
> What about the message in ep93xx_eth_init_module()?  Would you prefer
> that one to stay?

Most drivers I'm familiar with print a version message when they are
first instantiated -- perhaps that makes more sense.
