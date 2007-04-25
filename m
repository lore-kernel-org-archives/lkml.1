Return-Path: <linux-kernel-owner+w=401wt.eu-S1161625AbXDYG65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161625AbXDYG65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423237AbXDYG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:58:57 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:39246 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161625AbXDYG64 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:58:56 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=pnJGCiMXzKUyNkUaexaHqFSsgW0a1samNF3nV6VCv88ukRgjjDlrD37XCxL/DejMwIz53rbXrZDjs+GkHEilNdp6F8TRI+g73TwQX1zbfHVpTx+5j6z21XVWC9hDeb3P;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.14,449,1170630000"; 
   d="scan'208";a="66437848"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: NonExecutable Bit in 32Bit
Date: Wed, 25 Apr 2007 08:58:33 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530264B@ABGEX01E.abg.fsc.net>
In-Reply-To: <4ac8254d0704242337m518d87c3y8a26df66632ea6e4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NonExecutable Bit in 32Bit
Thread-Index: AceHBDqe7GysyQLRSYy1MW1lqhCDpgAApv5g
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net> <Pine.LNX.4.64.0704240640470.25153@server.thyself> <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net> <4ac8254d0704242333g17972a7q2106015af946ea5@mail.gmail.com> <4ac8254d0704242337m518d87c3y8a26df66632ea6e4@mail.gmail.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 06:58:54.0715 (UTC) FILETIME=[303CA4B0:01C78707]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > CONFIG_HIGHMEM64G=y
> > > > CONFIG_HIGHMEM=y
> > > > CONFIG_X86_PAE=y
> > >
> > > Ok in highmem it's active, whats about lowmem?
> > > x86-64 is NX active for lowmem too AFAIK.
> >
> > It's more of an issue of having PAE enabled.
> > Without PAE you are not able to use the the NX bit.
> That's the way the CPU works, not Linux.
> 
> Forgot to add:
> from arch/i386/Kconfig:
> config X86_PAE
> 	bool
> 	depends on HIGHMEM64G
> 	default y
> 	select RESOURCES_64BIT
> 
> > Hope this helps.
> >

Just that I get it right, NX just works with PAE enabled, and PAE just works with HIGHMEM64G enabled.
And this prevents the lowmemory to be secured by NX?

Ciao Thilo
