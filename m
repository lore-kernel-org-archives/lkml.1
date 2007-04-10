Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXDJXuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXDJXuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161125AbXDJXuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:50:32 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:42301 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161104AbXDJXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:50:31 -0400
X-IronPort-AV: i="4.14,392,1170651600"; 
   d="scan'208"; a="26909856:sNHT24774127"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Howells" <dhowells@redhat.com>, uaca@alumni.uv.es
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Date: Tue, 10 Apr 2007 19:52:04 -0400
User-Agent: KMail/1.9.5
Cc: bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, "Aubrey Li" <aubreylee@gmail.com>,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <200704091146.32346.rgetz@blackfin.uclinux.org> <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com>
In-Reply-To: <9561.1176209728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704101952.05380.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Apr 2007 23:50:25.0265 (UTC) FILETIME=[026D6610:01C77BCB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10 Apr 2007 08:55, David Howells pondered:
> Looking at alloc_pg_vec() in af_packet.c, I will place my bets on the
> latter case.  I don't know that this is a problem; it depends on how things
> work, and that I don't know offhand.  If someone can give me a simple test
> program, I would be able to evaluate it better.

Hmm - the only think I have used in the past is tcpdump/libpcap from
http://public.lanl.gov/cpw/

Documentation/networking/packet_mmap.txt also seems to be a little dated, but 
does have some code snippets if you wanted to make something lightweight...

Does anyone else on netdev have a small test app?

-Robin
