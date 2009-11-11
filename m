Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZKKKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZKKKUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZKKKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:20:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38417 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753383AbZKKKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:20:29 -0500
Date: Wed, 11 Nov 2009 10:21:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111102136.407105f4@lxorguk.ukuu.org.uk>
In-Reply-To: <20091110220652.GE26633@1wt.eu>
References: <20091110105642.215804e0@lxorguk.ukuu.org.uk>
	<4AF99E04.8080704@zytor.com>
	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
	<4AF9B5AB.5010800@zytor.com>
	<4AF9C3EF.6000705@redhat.com>
	<4AF9C6AB.8080006@zytor.com>
	<20091110201602.GA26633@1wt.eu>
	<20091110205445.GB1407@ucw.cz>
	<20091110211259.GD26633@1wt.eu>
	<4AF9D8E2.7050205@zytor.com>
	<20091110220652.GE26633@1wt.eu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So in my opinion, we should have :
>   - CMOV (for 486, Pentium, C3, K6, ...)
>   - NOPL (newcomer)
> 
> And if we want to extend down to i386 :
>   - BSWAP (=htonl)
>   - CMPXCHG (mutex)
>   - XADD (never encoutered but cheap)
> 
> I still have the 2.4 patch for BSWAP, CMPXCHG, CMOV and XADD lying

If we go that far it needs a lot more thought and probably to use the KVM
code simply because of all the complexities around prefixes and the like

(Not of course that the real CPUs are consistent either)

