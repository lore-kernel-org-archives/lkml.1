Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXKEGbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXKEGbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 01:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXKEGbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 01:31:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:6521 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXKEGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 01:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HOz6shpACWmFmp5COezSWLUSe0GbD9WHttN4FXnd9P0bcyj7LP3Rb6OUDTfJLHeq1rG8pmlQLHJ4KT9GLgF+X+L+QPfjbmSn4jp96ujCcTUrB8rAwY0UGraP/debKx2xQKIsDn8LGrcPFH7d7/8BWyy9Tf29D/WyB9YQ9X+SJCk=
Message-ID: <9c9fda240711042231s1f698683o20eb5332879d3ec5@mail.gmail.com>
Date: Mon, 5 Nov 2007 15:31:43 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: USB device DMA support on OMAP2
Cc: linux-omap-open-source@linux.omap.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, tony@atomide.com
In-Reply-To: <20071105062408.46E6423CA67@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105053815.GA2036@party>
	 <20071105062408.46E6423CA67@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Google-Sender-Auth: 31541f5475dd229b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, David Brownell <david-b@pacbell.net> wrote:
> > The current omap udc dosen't support the DMA mode
>
> It most certainly does!!  I think you it has DMA issues on OMAP2.
>

Ah, Yes, OMAP1 supports the DMA mode. It means the OMAP2 DMA support.

>
> > and it has some problem at setup time on OMAP2 with previous patch file.
> > I found that the code assumes bulk out required the big data transfer.
> > But MODE SELECT(6) sent the only 24 bytes. it makes a problem.
> > So I implement the small packets handling for it.
> >
> > It is tested with both linux and windows.
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> I'll have a look at it, thanks.
>
> Is this aginst the linux-omap tree, or current kernel.org code?
> (There _shouldn't_ be any differences, but I've not checked in
> some time now and such issues do creep in from time to time.)
>

There's some difference related with double buffering.
It's against the latest kernel code. I checked it.

Thank you,
Kyungmin Park
