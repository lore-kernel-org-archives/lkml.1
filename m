Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZFXVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZFXVLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZFXVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:11:47 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:18151 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZFXVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:11:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAMwzQkrCTtAn/2dsb2JhbACBUdJzhAwF
Date: Wed, 24 Jun 2009 23:11:44 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68k: restore lost coldfire
	CLOCK_TICK_RATE
Message-ID: <20090624211144.GA13167@frolo.macqel>
References: <20090620201147.GA14095@frolo.macqel> <4A3EF81F.1060300@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3EF81F.1060300@snapgear.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Jun 22, 2009 at 01:18:55PM +1000, Greg Ungerer wrote:
> HI Philippe,
>
> Philippe De Muyter wrote:
>> Hello list,
>> The good definition of CLOCK_TICK_RATE for coldfires has been lost in the
>> merge of m68k and m68knommu include files.  Restore it.  Culprit :
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ebafc17468d58bd903c886175ca84a4edc69ae1d;hp=34055b806a6334624e7e8af6eefc3aee42372a85
>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> Is it needed?
> What is broken with the existing value?

I am no ntp expert, but IIRC kernel/time/ntp.c needs to know the remainder
of CLOCK_TICK_RATE / HZ to obtain a good stability of the time.  That's
probably only needed when you have ntpd running.

Philippe
