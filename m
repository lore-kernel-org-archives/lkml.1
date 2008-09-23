Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYIWHEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYIWHEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYIWHEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:04:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:23170 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYIWHEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=VKbHlOX4uHdYv03H5SGXfLiCg9hAX7TVMMzCjahXj5sBQ390oJUvl2CrLa0CEI6Qpy
         SIpXbZ5OdaIghGbrYonVQLwUgu8l+uvzEE7lqBs7CphA701WYTLP+4QqhFWLaZCzNw1i
         aKi5bTkgnAivu3uhfuxhYHxUG4K0IJ3k3nANs=
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: OOPS bug KERNEL LINUX- Version 2.6.26
Date: Tue, 23 Sep 2008 09:04:31 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, andrea_monta@inwind.it,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, stable@kernel.org
References: <K7M9ZI$69A44BBF23D86D612A80B0EA98EEEE6B@libero.it> <200809230032.37255.IvDoorn@gmail.com> <20080922234649.GA26219@tuxdriver.com>
In-Reply-To: <20080922234649.GA26219@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809230904.31382.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2008, John W. Linville wrote:
> On Tue, Sep 23, 2008 at 12:32:36AM +0200, Ivo van Doorn wrote:
> > On Tuesday 23 September 2008, John W. Linville wrote:
> > > On Tue, Sep 23, 2008 at 12:25:03AM +0200, Ivo van Doorn wrote:
> > > > Hi,
> > > > 
> > > > > > 1. Problem with usb-wireless-key 
> > > > > > 2. I can't find my device typing ifconfig -a or iwconfig I don't find any wireless attached device. But I have my usb wireless connected. A belkin usb wireless key.Before, with the kernel 2.6.25 all worked well
> > > > > > 3. nothing
> > > > > > 4. Linux version 2.6.26 (root@clementino) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Mon Sep 22 15:57:45 CEST 2008
> > > > > > 5.
> > > > 
> > > > You missed the message from rt2x00 2 lines above this trace, which undoubtly have said something like:
> > > > 	"Invalid RT chipset detected."
> > > > which is triggered when rt73usb is loaded for a device it does not support
> > > > 
> > > > The current workaround for this issue is blacklisting rt73usb and making sure the driver
> > > > which is required for your driver is loaded instead.
> > > > 
> > > > I'll look into the reason why this actually triggers a NULL pointer, since that is obviously a nasty bug.
> > > 
> > > -stable needs a patch similar to the one here:
> > > 
> > > 	http://people.redhat.com/linville/kernels/rhel5/patches/jwltest-rt2x00lib-probe-fail.patch
> > 
> > Ah yes, that would be a good one.
> > I kind of assumed it was already merged, and hadn't actually verified that yet. ;)
> 
> Well the code in 2.6.27 is different, this patch is no longer necessary
> (and doesn't apply).

Yeah, but it was send to stable@kernel.org as merge request for 2.6.26 stable only. :)

Ivo
