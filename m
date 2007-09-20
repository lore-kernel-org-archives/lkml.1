Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbXITVxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbXITVxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXITVxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:53:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41059
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843AbXITVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:53:21 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 20 Sep 2007 17:53:10 -0500
User-Agent: KMail/1.9.6
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-tiny@selenic.com,
       "Tim Bird" <tim.bird@am.sony.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "Michael Opdenacker" <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <200709201702.08126.rob@landley.net> <6934efce0709201422r252b5fbbiaa1c7afdf938c7c6@mail.gmail.com>
In-Reply-To: <6934efce0709201422r252b5fbbiaa1c7afdf938c7c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201753.10542.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007 4:22:37 pm Jared Hulbert wrote:
> > > I think that this idea is not worth it.
>
> Don't use the config option then....
>
> > My problem is that switching off printk is the single biggest bloat
> > cutter in the kernel, yet it makes the resulting system very hard to
> > support.  It combines a big upside with a big downside, and I'd like
> > something in between.
>
> It's not such a big downside IMHO.  You can support a kernel without
> printk.  Need to debug the kernel without printk?  Use a JTAG
> debugger...

I don't actually own a jtag.  (I do use qemu's gdb support to debug the target 
kernel, but it's darn awkward and has limited hardware support.)

> If you have a system that actually configures out printk's, chances
> are you don't have storage and output mechanisms to do much with the
> messages anyway.  Think embedded _products_ here.

I plead the fifth.

> Sure the 
> development boards have serial, ethernet, and all that jazz but tens
> of millions of ARM based gadgets don't.

I wonder if that "Monsoon" gadget does?  (Sorry, just on my mind today...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
