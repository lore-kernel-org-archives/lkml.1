Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXIKVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXIKVke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXIKVkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:40:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:27120 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbXIKVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ae5hsHouEpjS2SXxUpstaItL3zQqCN5Z1cDbCCE7xdweCvWnoeXre9LDcMMn11t9Wfcs58r9He/Wa+t9XMK/GCHJmqNNvMy0o6SBNyGUeAfgVQegOXAer44oQPQLNeh4owaEvtxQojWqbrRWC9SdATQkOC0mca55I01XGkNFUQU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and SW/MW DMA mode masks (take 2)
Date: Tue, 11 Sep 2007 22:52:02 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709022344.18565.sshtylyov@ru.mvista.com> <46E2900D.5010004@ru.mvista.com>
In-Reply-To: <46E2900D.5010004@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709112252.02576.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 08 September 2007, Sergei Shtylyov wrote:
> Once I quothed:
> 
> > Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While at it,
> > make the udma_filter() method calls take precedence over using the mode masks.
> 
>     This one not looking to pretty -- I've geve some thought on how to 
> beautify all these switch fallthoughs but haven't got something much better 
> then uour original approach (AKA Occam's razor :-).

Care to recast the patch to contain only udma_filter() part?

BTW ide_rate_filter() still lacks respecting PIO limits of the device
(Occam's razor doesn't apply to "PIO side" of ide_rate_filter() ;-)

Thanks,
Bart
