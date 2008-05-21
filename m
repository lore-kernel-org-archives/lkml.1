Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbYEUX4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbYEUX4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbYEUX4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:56:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYEUX4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:56:05 -0400
Message-ID: <4834B670.80606@zytor.com>
Date: Wed, 21 May 2008 16:55:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org> <4832E461.2070503@zytor.com> <20080520151655.GA542@redhat.com> <4833112F.7020402@zytor.com> <20080520191812.GB31805@redhat.com>
In-Reply-To: <20080520191812.GB31805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> Moving along the same direction..  Moving the vendor specific bits out of setup_64.c
> into cpu/ would go a long way towards killing of setup64.c.  I took a first pass at doing this
> in the diff below. So far I only looked at the AMD specific bits, and haven't done
> a complete conversion to cpu_dev style initialisation as done on 32bit, but that
> can easily be performed later after moving all the code out into its respective places.
> (downside: a bunch of externs in the interim).
> 
> comments on this before I go any further?
> 

Hi Dave,

I was going to pull this into -tip, but I need a Signed-off-by: line in 
order to do so.  Could you resend this so we can add it to -tip?

	-hpa
