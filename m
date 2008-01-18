Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYARMOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYARMOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYARMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:14:40 -0500
Received: from free-electrons.com ([88.191.23.47]:56778 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYARMOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:14:40 -0500
Message-ID: <47909821.1090907@free-electrons.com>
Date: Fri, 18 Jan 2008 13:14:25 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86: fix unconditional	arch/x86/kernel/pcspeaker.c?compiling
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu>
In-Reply-To: <20080118110252.GA17397@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 12:02 PM, Ingo Molnar wrote:
>
> why didnt you make this:
>
>   obj-$(CONFIG_INPUT_PCSPKR)		+= pcspeaker.o
>
> ?
>   
Many thanks for your feedback.

That's what I did first, but if  CONFIG_INPUT_PCSPKR=m,
arch/x86/kernel/pcspeaker.c gets compiled as a module. While compiling
doesn't fail, is this still a valid module? It defines no init and exit
functions, and it defines an initcall, which only makes sense at boot time.

We could make pcspeaker.c depend on another switch, like
CONFIG_PCSPEAKER on mips. We could offer the possibility to disable it
when CONFIG_EMBEDDED is set.

What do you think?

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

