Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZEGXMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZEGXMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZEGXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:12:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34147 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbZEGXM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:12:28 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905071843100.3868-100000@netrider.rowland.org>
References: <ac3eb2510905071439j7736711axc729008923435cea@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905071843100.3868-100000@netrider.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 8 May 2009 01:12:07 +0200
Message-ID: <ac3eb2510905071612v61a27760hffc684ee87df9249@mail.gmail.com>
Subject: Re: usbfs, claiming entire usb devices
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 00:47, Alan Stern <stern@rowland.harvard.edu> wrote:

>> Or is that a specific requirement where things would go wrong when the
>> kernel binds to a device first?
>
> You've got it.  Sometimes devices are in a very precarious state (such
> as during a firmware update) and they need to go into a particular
> configuration.  Letting the kernel install some random configuration at
> such times doesn't work.

I see.

You mentioned earlier, that you would need to match the holder of the
"lock" and the one that accesses the device?

Wouldn't it be sufficient already, if you can take a "lock" at the
specific port, that prevents the kernel to access the device when it
shows up?

You thought of supporting a number of different users, with different
uids, or would that be a root-only action?

Thanks,
Kay
