Return-Path: <linux-kernel-owner+w=401wt.eu-S1750991AbYEWPte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbYEWPte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYEWPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:49:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47316 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbYEWPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:49:09 -0400
Date: Fri, 23 May 2008 16:33:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Haroldo Gamal <gamal@alternex.com.br>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
 kernel	image
Message-ID: <20080523163303.492c89e4@core>
In-Reply-To: <1211554711.28967.25.camel@pmac.infradead.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<s5hbq2xul4s.wl%tiwai@suse.de>
	<1211554711.28967.25.camel@pmac.infradead.org>
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

> Yeah, I thought about that. I was slightly concerned that drivers might
> actually try to _modify_ the firmware they loaded, though. As it is,
> there's no fundamental reason why they shouldn't do that.

I've not seen any that do and judicious use of "const" should catch
offenders.
