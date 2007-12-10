Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbXLJN1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbXLJN1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbXLJN1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:27:06 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:52936 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbXLJN1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:27:04 -0500
Date: Mon, 10 Dec 2007 13:26:35 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210132635.GA12913@linux-mips.org>
References: <200710122305.l9CN5tFI008240@hera.kernel.org> <1196899818.7033.11.camel@pasglop> <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net> <1196917447.7033.17.camel@pasglop> <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net> <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org> <1197185091.6572.38.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197185091.6572.38.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 06:24:51PM +1100, Benjamin Herrenschmidt wrote:

> If that is the case though (that is it can't issue low ioport cycles),
> how would have the fd6e7321...  worked in the first place ? Hrm...
> strange. My understanding is that all that patch does is put junk in the
> pci_dev resource structures :-) Maybe that's enough to cause the PCI
> layer later on to be unhappy about them and reassign the BARs to some
> place that works ? In which case, you are right, a better approach is a
> quirk on this specific platform, or even better, mark 0...0x10000000
> busy in ioport_resources and let the generic code clash & re-assign...
> 
> I must admit I'm a bit confused tho...
> 
> Anyway, so far, nobody is arguing in favor of keeping this patch in nor
> so far trying and explanation on why it wouldn't be totally bogus, so I
> suggest we revert it :-)

I certainly don't oppose at this point.

  Ralf
