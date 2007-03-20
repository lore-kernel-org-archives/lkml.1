Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXCTQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXCTQF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXCTQF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:05:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbXCTQF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:05:26 -0400
Message-ID: <46000633.5000900@redhat.com>
Date: Tue, 20 Mar 2007 12:05:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: soft lockup during suspend
References: <20070320123253.GB19019@elf.ucw.cz> <s5htzwgccq3.wl%tiwai@suse.de>
In-Reply-To: <s5htzwgccq3.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> 
> X60/T60 is known to be often broken regarding the communication
> between the controller and the codec chip.  When this kind of thing
> happens, the driver tries to switch to a single-shot I/O without using
> ring-buffers and IRQs, and even in such a mode, the communication gets
> broken.  FWIW, it doesn't happen on other machines with HD-audio, so
> it's fairly specific to X60/T60.  No idea why.

What about Acer Aspire 5102?

http://lkml.org/lkml/2006/12/3/9

