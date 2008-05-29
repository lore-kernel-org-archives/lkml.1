Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYE2LDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYE2LDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYE2LDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:03:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbYE2LDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:03:38 -0400
Date: Thu, 29 May 2008 11:49:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few
 uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080529114941.099d8e2c@core>
In-Reply-To: <Pine.LNX.4.62.0805282319090.19567@ikari.dreamhost.com>
References: <Pine.LNX.4.62.0805282319090.19567@ikari.dreamhost.com>
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

On Wed, 28 May 2008 23:23:26 -0700 (PDT)
Chris Peterson <cpeterso@cpeterso.com> wrote:

> 
> Remove network drivers' last few uses of theoretically-exploitable network 
> entropy. Only 12 net drivers are affected. Headless boxes should use a 
> more secure source of entropy, such as the userspace daemons rngd, clrngd, 
> egd, audio_entropyd, and/or video_entroyd.
> 
> I'm also thinking about writing a "Frankenstein" daemon that combines the 
> entropy-collecting algorithms from those daemons into one. Whereas rngd 
> only uses /dev/hw_random, my hypothetical daemon would make a best effort 
> attempt: use /dev/hw_random if it exists, otherwise fallback (or use in 
> addition) the other entropy sources.
> 
> 
> Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>

Acked-by: Alan Cox <alan@redhat.com>
