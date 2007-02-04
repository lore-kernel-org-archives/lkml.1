Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXBDPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXBDPno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXBDPno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:43:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40996 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752391AbXBDPnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:43:43 -0500
Date: Sun, 4 Feb 2007 16:43:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
Message-ID: <20070204154335.GB2032@elf.ucw.cz>
References: <1170241008.6512.10.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170241008.6512.10.camel@Homer.simpson.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I received the below upon first poke of firefox icon after a resume.  
> 
> See attachment (evolution refuses to inline it).

Is it repeatable? You may want to try with smaller set of
modules... prism54 is quite unusual...

								Pavel

>  BUG: unable to handle kernel NULL pointer dereference at virtual address 00000002
> printing eip:
> c109a7cf
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP 
> Modules linked in: xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss eeprom snd_seq_midi snd_seq_midi_event snd_seq edd button battery ac ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat ip_nat iptable_filter ip6table_mangle ip_conntrack nfnetlink ip_tables ip6table_filter ip6_tables x_tables nls_iso8859_1 nls_cp437 nls_utf8 snd_mpu401 snd_mpu401_uart snd_rawmidi snd_seq_device ohci1394 ieee1394 prism54 snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 sd_mod fan thermal processor
> CPU:    0


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
