Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbXH3Lze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbXH3Lze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXH3LzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:55:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXH3LzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:55:23 -0400
Date: Thu, 30 Aug 2007 13:50:59 +0200
To: Matthew Wilcox <matthew@wil.cx>
Cc: andre@finow14.de, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [KJ][patch 3/3] VIDC20: use abs() from kernel.h instead of own definition
Message-ID: <20070830115059.GA17168@ahaupt-debian-vm.localdomain>
References: <20070830102551.131398783@finow14.de> <20070830104038.GD14925@ahaupt-debian-vm.localdomain> <20070830111746.GS14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070830111746.GS14130@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@finow14.de>
X-Provags-ID: V01U2FsdGVkX19vDXs1f2ZrQPPDmTMT3qco8WFmcZ+xFHyuB70
 YYvZlK6TBQ6f2rm3B5apTpkTxM5Iw7VAEOhwvuyoW2pfq3qH2/
 p+NELcI6CbeM9AvdODO8y9lloKU9BgJ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 05:17:47AM -0600, Matthew Wilcox wrote:
> On Thu, Aug 30, 2007 at 12:40:38PM +0200, andre@finow14.de wrote:
> > -		diff_int = my_abs(rate_ext-rate);
> > -		diff_ext = my_abs(rate_int-rate);
> > +		diff_int = abs(rate_ext-rate);
> > +		diff_ext = abs(rate_int-rate);
> 
> Nothing to do with the patch, but is this really correct?  Surely it
> should be diff_ext = abs(rate_ext-rate) ?

hmmh, not sure about this ...

Russell?


regards,

Andre
