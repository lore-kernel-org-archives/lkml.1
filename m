Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXFRQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXFRQYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXFRQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:24:03 -0400
Received: from saeurebad.de ([85.214.36.134]:45769 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbXFRQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:24:01 -0400
Date: Mon, 18 Jun 2007 18:23:54 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: dj@david-web.co.uk, Jaroslav Kysela <perex@suse.cz>
Subject: Re: Sound plays at half speed; intel8x0 clock issue
Message-ID: <20070618162354.GA32754@saeurebad.de>
Mail-Followup-To: linux-kernel@vger.kernel.org, dj@david-web.co.uk,
	Jaroslav Kysela <perex@suse.cz>
References: <200706181337.43868.dj@david-web.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706181337.43868.dj@david-web.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 18, 2007 at 01:37:43PM +0100, David Johnson wrote:
> Hi,
> 
> I'm running vanilla 2.6.21.5 on a Winfast NF4UK8AA motherboard and sound is 
> playing at half-speed.
> 
> I get the following output in dmesg:
> intel8x0_measure_ac97_clock: measured 51345 usecs
> intel8x0: measured clock 29136 rejected
> intel8x0: clocking to 48000
> 
> lspci says:
> 00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio 
> Controller (rev a2)

Could you give the output of

	lspci -vv -s 00:04.0

and
	cat /proc/asound/card0/codec97#0/ac97#0-0

? You should run lspci as superuser to get all device capabilities listed.

I also added Jaroslav to CC.

	Hannes
