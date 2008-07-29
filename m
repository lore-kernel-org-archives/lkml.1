Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYG2IQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYG2IQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYG2IQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:16:14 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:46395 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393AbYG2IQM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:16:12 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2008 10:15:56 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Samuel Sieb <samuel@sieb.net>,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
References: <48841A92.4020301@sieb.net> <4886DB31.8070306@sieb.net> <20080728153224.GA28495@elte.hu>
In-Reply-To: <20080728153224.GA28495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807291015.57992.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 28. Juli 2008, Ingo Molnar wrote:
> * Samuel Sieb <samuel@sieb.net> wrote:
> >> The only critical tweak I found is the one that changes the
> >> "Performance Control Incrementer" because its settings depends on the
> >> CPU's core frequency. Maybe this tweak should be removed, because the
> >> BIOS (hopefully) set it in a way the hardware supports.
> >
> > This was the only line that was a problem.  See the other branch of
> > this thread with Juergen Beisert.
>
> any patch we should pick up to make your box boot?

We could simply delete the lines that change the incrementor setup (in the 
hope the BIOS did it in a correct way).
Or we need access to the stepping number of the CPU (my old Media GX datasheet 
tells me, you can enable or disable a "Performance Control Incrementer" in 
this device, but there are no bits to set different increment values) and the 
core CPU clock speed (on Geode GX CPUs you can enable and disable 
the "Performance Control Incrementer" and - when enabled - you also must 
setup a correct increment value according to the core CPU clock).

Juergen

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
