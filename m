Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXKEGYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXKEGYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXKEGYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:24:12 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:38355 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751441AbXKEGYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:24:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=1V9grkKWwWZtrrfccGFNHWhGBLww4Kb9tcISKu5GnxHpcSi8c71+7x7hI3YDhykUsRspbfnskB2JenP3U6fzi50MD/Gz3bz2HA/4vUNkqFZ7sSK8uc5a0XlnXkFd14wjbhDIhfwwX7bHK+BDW//uGSQ4iVlLR/bUdIkApUXayxI=  ;
X-YMail-OSG: RY4Pn6YVM1l7Gsi1PXaugTBR1gogh76YaUGYLwts7M8DPmz8R1USYwULfy3zscVJc7DRZ1VSS.H6emF1YrJjpXBPBpioGs9TEJ7llvK8Z0Bz3FnMdMNBuJe7YsG5
Date: Sun, 04 Nov 2007 22:24:08 -0800
From: David Brownell <david-b@pacbell.net>
To: linux-omap-open-source@linux.omap.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: USB device DMA support on OMAP2
Cc: tony@atomide.com
References: <20071105053815.GA2036@party>
In-Reply-To: <20071105053815.GA2036@party>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071105062408.46E6423CA67@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The current omap udc dosen't support the DMA mode

It most certainly does!!  I think you it has DMA issues on OMAP2.


> and it has some problem at setup time on OMAP2 with previous patch file.
> I found that the code assumes bulk out required the big data transfer.
> But MODE SELECT(6) sent the only 24 bytes. it makes a problem.
> So I implement the small packets handling for it.
>
> It is tested with both linux and windows.
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I'll have a look at it, thanks.

Is this aginst the linux-omap tree, or current kernel.org code?
(There _shouldn't_ be any differences, but I've not checked in
some time now and such issues do creep in from time to time.)

- Dave

