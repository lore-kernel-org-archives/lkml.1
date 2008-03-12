Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYCLTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYCLTeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYCLTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:34:08 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44543 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYCLTeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:34:06 -0400
Message-ID: <47D8304C.3090005@keyaccess.nl>
Date: Wed, 12 Mar 2008 20:34:36 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Michael Cree <mcree@orcon.net.nz>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080312144021.3FE57DBA2@gherkin.frus.com>
In-Reply-To: <20080312144021.3FE57DBA2@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-08 15:40, Bob Tracy wrote:

> Well, I built a 2.6.22 kernel last night, and in tests this morning
> there's no difference relative to the ALSA behavior seen in 2.6.25-rc4.

Okay. If someone is tracking this as a 2.6.25 regresion, it can be stricken 
of that list.

> Since the question came up (or was strongly implied), I took the time to
> check the status of IRQ 5 in /proc/interrupts, and while it shows up as
> assigned to the sound card, no interrupts are being seen/processed by
> the es18xx driver.

That is indeed what it soundeed like, or the first bit at least.

> When I remove the snd-es18xx module and install the snd-sb8 module with
> the same parameters (other than there's no second DMA channel), the
> /proc/interrupts counter for IRQ 5 increments as expected when playing
> sound files.

What does cat /proc/config.gz | grep CONFIG_ALPHA_ say? Miuchael, and for 
you? For some Alpha configs, arch/alpha/kernel/es1888.c is compiled and for 
some not. I expect for you (Bob) it's compiled in? And Michael?

Rene.
