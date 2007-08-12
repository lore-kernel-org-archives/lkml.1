Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXHLUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXHLUjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXHLUjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:39:11 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:46862 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590AbXHLUjK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:39:10 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Vadim Dyadkin <dyadkin@lns.pnpi.spb.ru>
Subject: Re: troubles with r8169
Date: Sun, 12 Aug 2007 21:38:58 +0100
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <fa.BZqd/vLw75Xm+ORj+HLjUzU1hSw@ifi.uio.no> <46BF61AB.5060400@shaw.ca> <46BF6853.4020800@lns.pnpi.spb.ru>
In-Reply-To: <46BF6853.4020800@lns.pnpi.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708122138.58405.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 21:06:43 Vadim Dyadkin wrote:
> Robert Hancock пишет:
> > This could well be a problem with the nvidia driver as it shares the
> > same IRQ. The first step would be to see if the problem still shows up
> > without the nvidia binary module loaded.
>
> Thank for your answer. This problem never shows up if I use only nvidia
> driver (the work without network), or if I use only r8169 (without
> x.org). If I use both of them I have the hang. Usually the hang appears
> if OpenGL is used or network rate is maximal. I tested this regimes many
> times before.

If you haven't already, I'd drop linux-bugs@nvidia.com an email to see if they 
have any insight. Not that this can't be a kernel bug, just that it's a bit 
difficult for kernel developers to debug when you're using a driver for which 
we don't have the sources.

As for changing the IRQ assignments, I don't have any immediate suggestions. I 
notice that this laptop has a dual core processor, so I'm guessing disabling 
APIC isn't an option. Have you tried that anyway, just to see if the IRQ 
assignment differs?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

