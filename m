Return-Path: <linux-kernel-owner+w=401wt.eu-S2992690AbXCBWnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992690AbXCBWnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992641AbXCBWnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:43:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992645AbXCBWnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:43:05 -0500
Message-ID: <45E8A873.30604@garzik.org>
Date: Fri, 02 Mar 2007 17:42:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org
Subject: Re: [PATCH] libata-core: Fix simplex handling
References: <20070301173646.4138981b@lxorguk.ukuu.org.uk>
In-Reply-To: <20070301173646.4138981b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> The initial simplex handling code is fooled if you suspend and resume.
> This also causes problems with some single channel controllers which
> claim to be simplex.
> 
> The fix is fairly simple, instead of keeping a flag to remember if we
> gave away the simplex channel we remember the actual owner. As the owner
> is always part of the host_set we don't even need a refcount.
> 
> Knowing the owner also means we can reassign simplex DMA channels in
> future hotplug code etc if we need to
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> (and a signed-off for the patch I sent before while I remember)

applied


