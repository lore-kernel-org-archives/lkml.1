Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZDFTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZDFTBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZDFTBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:01:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50769 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbZDFTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:01:07 -0400
Date: Mon, 6 Apr 2009 20:00:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Peterson <cpeterso@cpeterso.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Message-ID: <20090406200025.67cc558a@lxorguk.ukuu.org.uk>
In-Reply-To: <200904061430.26276.rgetz@blackfin.uclinux.org>
References: <200904061430.26276.rgetz@blackfin.uclinux.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 14:30:26 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> Although there was some discussion  
> http://thread.gmane.org/gmane.linux.kernel/680723
> 
> about removing IRQF_SAMPLE_RANDOM from the remaining network drivers in May of 
> 2008, but they still appears to be there in 2.6.29.

These are mostly unmaintained drivers. Dunno why tg3 isn't fixed - it has
some mitigation logic so maybe its not observable


> I can put a scope/analyser on a device - and look at the touchscreens, serial 
> devices, USB, all without cracking the case. 

But you can observe a network interface accurately from all over the lan
(and with a ten dollar card), or a good deal further (I believe up to 1Km
in the right conditions was claimed by some

If you need absolute hard entropy then use a real entropy source, if not
then your user space is using the wrong device file - the blocking for
entropy one. At that point it depends how vital your SSL is to you and
what it protects.

Alan
