Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbYAPVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbYAPVYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYAPVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:23:49 -0500
Received: from www.tglx.de ([62.245.132.106]:56911 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYAPVXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:23:47 -0500
Date: Wed, 16 Jan 2008 22:23:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Balaji Rao <balajirrao@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: setting jiffies as the clocksource stops time
In-Reply-To: <200801170209.42138.balajirrao@gmail.com>
Message-ID: <alpine.LFD.0.99999.0801162221100.4372@localhost.localdomain>
References: <200801170209.42138.balajirrao@gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Balaji Rao wrote:
> When i set jiffies as the current_clocksource, date(1) tells me that wallclock time has stopped, and soon after that, the 
> system becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
> 
> This happens in 2.6.24-rc4,rc5, and even in rc8.

It happens since 2.6.21-rc1 on 32 bit.
 
> Thomas, Ingo what are your thoughts on this ?

http://lkml.org/lkml/2008/1/16/123

Thanks,
	tglx
