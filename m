Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbXJHMrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbXJHMrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXJHMrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:47:35 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:37313 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbXJHMre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:47:34 -0400
Message-ID: <470A26E3.7030100@lncsa.com>
Date: Mon, 08 Oct 2007 14:47:31 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: drbd-user@linbit.com, linux-kernel@vger.kernel.org
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
References: <20071004092111.ahweigho@trusted.lncsa.com> <20071007233618.GV995458@sgi.com>
In-Reply-To: <20071007233618.GV995458@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Can you turn on slab debug and poisoning and see where
> the kernel fails with that? e.g. set:
> 
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y


I was a little worried about letting those servers in such a bad state,
and went the "easy" way.

I did upgrade from drbd 0.7.X to latest svn 8.0.X

Laurent

PS: Should this bug reappear, i'll change the kernel's config, and let
you know the result.
