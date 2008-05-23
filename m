Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYEWUqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYEWUqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbYEWUqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:46:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60611 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757369AbYEWUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:46:23 -0400
Date: Fri, 23 May 2008 21:31:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
 kernel	image
Message-ID: <20080523213147.1b6be3d0@core>
In-Reply-To: <1211571743.28967.83.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<s5hbq2xul4s.wl%tiwai@suse.de>
	<1211554711.28967.25.camel@pmac.infradead.org>
	<20080523163303.492c89e4@core>
	<1211570047.28967.75.camel@pmac.infradead.org>
	<1211571743.28967.83.camel@pmac.infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's fairly much the kind of thing I was expecting we might see, I'm
> not sure it's reasonable to suddenly declare that overwriting the
> firmware is forbidden. I'd done the version which avoided the extra
> vmalloc and copy, but I've just reverted it.

It saves us a lot of memory in several cases where the drivers hang onto
the firmware so I definitely think we should fix the folks assuming they
can widdle on the firmware. That doesn't look hard to do and could save
50K+ on many systems.

Alan
