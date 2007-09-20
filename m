Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbXITVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbXITVWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXITVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:22:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:14969 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXITVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOyX/idL1Cu6IX3tNPQT5drJXRVrpEISPWWhlTm9Wpc54gsVS2MilFmPp8fottwrGzM2fDWdrCibo40wytvmR37gj4kPxr08igy2SfMY8F5PUb6Fk5v9obvM8rgv/xZTzw5m/XsjYHsGvn07BG8Z2ZIFKYoujQwyVxUczXVtGPc=
Message-ID: <6934efce0709201422r252b5fbbiaa1c7afdf938c7c6@mail.gmail.com>
Date: Thu, 20 Sep 2007 14:22:37 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [Announce] Linux-tiny project revival
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-tiny@selenic.com,
       "Tim Bird" <tim.bird@am.sony.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "Michael Opdenacker" <michael@free-electrons.com>
In-Reply-To: <200709201702.08126.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
	 <20070920195844.GA1805@martell.zuzino.mipt.ru>
	 <200709201702.08126.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think that this idea is not worth it.

Don't use the config option then....

> My problem is that switching off printk is the single biggest bloat cutter in
> the kernel, yet it makes the resulting system very hard to support.  It
> combines a big upside with a big downside, and I'd like something in between.

It's not such a big downside IMHO.  You can support a kernel without
printk.  Need to debug the kernel without printk?  Use a JTAG
debugger...

If you have a system that actually configures out printk's, chances
are you don't have storage and output mechanisms to do much with the
messages anyway.  Think embedded _products_ here.  Sure the
development boards have serial, ethernet, and all that jazz but tens
of millions of ARM based gadgets don't.
