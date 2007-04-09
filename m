Return-Path: <linux-kernel-owner+w=401wt.eu-S965396AbXDIUGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbXDIUGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965419AbXDIUGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:06:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:3705 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396AbXDIUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:06:49 -0400
X-IronPort-AV: i="4.14,388,1170651600"; 
   d="scan'208"; a="34355825:sNHT22238825"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Date: Mon, 9 Apr 2007 16:08:22 -0400
User-Agent: KMail/1.9.5
Cc: bryan.wu@analog.com, alan@lxorguk.ukuu.org.uk, waltje@uwalt.nl.mugnet.org,
       aubreylee@gmail.com, netdev@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>
References: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com> <20070409.095523.122833625.davem@davemloft.net> <20070409.114323.78734391.davem@davemloft.net>
In-Reply-To: <20070409.114323.78734391.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704091608.23270.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 09 Apr 2007 20:06:44.0157 (UTC) FILETIME=[986916D0:01C77AE2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 9 Apr 2007 14:43, David Miller pondered:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 09 Apr 2007 09:55:23 -0700 (PDT)
> >
> > I will apply this patch.
>
> Actually I won't, the other comments in this thread make a lot
> of sense, we should try to make it build and work just as we
> do for other similar things on no-MMU.

Great. Any pointers in the right direction to remove the requirement of 
vm_insert_page() in the noMMU case?

Thanks
-Robin
