Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXBKKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXBKKcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXBKKcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:32:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:6741 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbXBKKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TWc/znL+G1MhQl5YDg+CBQ32nJ2nYLZTYsuX2zpB43w7fAMePEPawxbzASAhmdwylhnj15SbKzBxJoxkwjxIrCazSJev9VWuQvFsrhOXoQSYiAXzRoIUw3g3yTOLJTHb26pOnMb6kPzE0OWbF4rgGSQcvVGP0X8pAMEdGJKM1Gw=
Message-ID: <1defaf580702110232p72012fa4pe89d0a488c2817f@mail.gmail.com>
Date: Sun, 11 Feb 2007 11:32:18 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG] PATA_PCMCIA does not work
Cc: Komuro <komurojun-mbn@nifty.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070211015619.39d3e29a@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	 <20061217040222.GD17561@ftp.linux.org.uk>
	 <20070211101537.e40fa309.komurojun-mbn@nifty.com>
	 <20070211015619.39d3e29a@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > [pata_pcmcia dmesg]
> > ata1.00: CFA, max PIO0, 20480 sectors: LBA
> > ata1.00: ata1: dev 0 multi count 0
> > ata1.01: CFA, max PIO0, 20480 sectors: LBA
> > ata1.01: ata1: dev 1 multi count 0
>
> Do you have two cards here ?

I've seen this as well, on an ancient 4MB card. I'm pretty sure the
-CSEL signal on my test board is incorrectly routed, so I thought it
was because of that. I'll try to strap it tomorrow and see if it
really is the cause of the problem.

> Your card should work with the current -mm driver although not entirely
> for the right reasons. Given you have such a marvellously buggy set of
> hardware can I send you some test patches to try ?

In my current pile of four CF cards, it looks like three of them are
buggy, although in slightly different ways. I'd be happy to test a few
patches.

Haavard
