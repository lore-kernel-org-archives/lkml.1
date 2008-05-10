Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYEJVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYEJVzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYEJVze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:55:34 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:56432 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYEJVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:55:33 -0400
Message-ID: <48261A29.9020308@keyaccess.nl>
Date: Sat, 10 May 2008 23:56:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PNP: add ISAPnP MPU option quirks
References: <481FAF79.2030407@keyaccess.nl> <200805061115.56737.bjorn.helgaas@hp.com> <482614B3.4000908@gmail.com> <48261832.70006@keyaccess.nl>
In-Reply-To: <48261832.70006@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-05-08 23:48, Rene Herman wrote:

> PNP: add ISAPnP MPU option quirks.
> 
> The AD181x and AZT230 chips don't support an IRQ-less MPU401 option
> but work fine without one. This adds (priority functional) IRQ-less
> options for each port option to help systems with few available IRQs.
> 
> The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
> penalizing the IRQ. Also, while not a practical issue due to no IRQ
> option being present for the dependents, this needs to add in front,
> not back.
> 
> Doesn't use pnp_register_port_resource() for symetry with above.
> 
> This does not delete the AD1815 independent option even though it
> should be empty after the IRQ transfer due to AD1816 coming with an
> empty but still present independent option by default.
> 
> Was tested on AD1815, AD1816 and AZT230. The ALSA snd-ad1818a driver

Typo: AZT2320

> also support the AZT2002 ID for MPU401 but this doesn't as I was
> unable to test it.
> 
> Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.
