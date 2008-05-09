Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbYEIMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbYEIMCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYEIMCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:02:12 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:40041 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYEIMCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:02:11 -0400
Message-ID: <48243D86.7020504@keyaccess.nl>
Date: Fri, 09 May 2008 14:03:18 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de>
In-Reply-To: <s5hzlr0105c.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-05-08 08:06, Takashi Iwai wrote:

> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
> implicit assumption that dev = NULL for ISA devices that require 24bit
> DMA.
> 
> How about the patch below?  It's against the latest Linus git tree.

Yes, works well. Thank you.

Rene.
