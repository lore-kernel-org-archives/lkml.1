Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXDJB6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXDJB6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXDJB6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:58:22 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:38049 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXDJB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:58:20 -0400
X-IronPort-AV: i="4.14,388,1170651600"; 
   d="scan'208"; a="26805382:sNHT24336641"
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: David Miller <davem@davemloft.net>, bryan.wu@analog.com,
       alan@lxorguk.ukuu.org.uk, waltje@uwalt.nl.mugnet.org,
       aubreylee@gmail.com, netdev@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <200704091608.23270.rgetz@blackfin.uclinux.org>
References: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com>
	 <20070409.095523.122833625.davem@davemloft.net>
	 <20070409.114323.78734391.davem@davemloft.net>
	 <200704091608.23270.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 10 Apr 2007 10:00:32 +0800
Message-Id: <1176170432.17975.10.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 16:08 -0400, Robin Getz wrote:
> On Mon 9 Apr 2007 14:43, David Miller pondered:
> > From: David Miller <davem@davemloft.net>
> > Date: Mon, 09 Apr 2007 09:55:23 -0700 (PDT)
> > >
> > > I will apply this patch.
> >
> > Actually I won't, the other comments in this thread make a lot
> > of sense, we should try to make it build and work just as we
> > do for other similar things on no-MMU.
> 
> Great. Any pointers in the right direction to remove the requirement of 
> vm_insert_page() in the noMMU case?
> 
> Thanks
> -Robin

OK, we will try to find other way to fix this bug according Robin's
comments.

Thanks
-Bryan
