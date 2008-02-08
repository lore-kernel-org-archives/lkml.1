Return-Path: <linux-kernel-owner+w=401wt.eu-S932620AbYBHBs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbYBHBs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYBHBsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:48:17 -0500
Received: from rfc2324.org ([89.149.194.216]:46522 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbYBHBsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:48:17 -0500
Date: Fri, 8 Feb 2008 02:48:05 +0100
From: Maximilian Wilhelm <max@rfc2324.org>
To: Krzysztof Oledzki <olel@ans.pl>, max@rfc2324.org,
       linux-kernel@vger.kernel.org, Eric.Moore@lsi.com
Subject: Re: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
Message-ID: <20080208014805.GG11236@outback.rfc2324.org>
Mail-Followup-To: Krzysztof Oledzki <olel@ans.pl>, max@rfc2324.org,
	linux-kernel@vger.kernel.org, Eric.Moore@lsi.com
References: <20080206210426.GD11236@outback.rfc2324.org> <47AB82DD.90201@ans.pl> <20080208012028.GF11236@outback.rfc2324.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080208012028.GF11236@outback.rfc2324.org>
X-Operating-System: Linux 2.6.23.9-grsec auf i686
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT d+(--) s+: a-- C++>$ UL++++$ US>++++ P++ L+++>++++ E--- W+ N o+ K- w O? M? V? PS+ PE Y+ PGP++ t 5? X- R tv b+(++) DI+(++) !D G++ e>+++  h!>--(---) r++ y+
X-message-Flag: Outlook: A programm to spread viri, but it can mail, too.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just noticed that Eric's address was wrong, so resend with corrected Cc.

Eric, my intial report was http://lkml.org/lkml/2008/2/6/300

> Am Thursday, den  7 February hub Krzysztof Oledzki folgendes in die Tasten:
> 
> Hi!
> 
> > >While installing my new firewall I got the following kernel panic in
> > >the MPT SAS driver which I need for the disks.
> 
> > >The first kernel I bootet was 2.6.23.14 which did panic so I tried a
> > >2.6.24 which panics, too. Our usual FAI kernel (2.6.23.9) is also
> > >affected.
> 
> > Could you please try 2.6.22-stable?
> 
> Yes it works :-/
> 
> I've put some things which on the web which might be helpful:
> 
> dmesg		http://files.rfc2324.org/mptsas_panic/2.6.22-dmesg
> lspci -v	http://files.rfc2324.org/mptsas_panic/2.6.22-lspci-v
> .config		http://files.rfc2324.org/mptsas_panic/2.6.22-config
> 
> I'll search for the last working kernel and try to break it down to a
> commit tommorow when I can get a serial console or direct access.
> The Java driven console redirection is everything else than fulfilling :-(
> 
> > It looks *very* similar to my problem:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9909
> 
> It seems to be the same controller:
> 
> 01:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
> 	Subsystem: Dell Unknown device 1f10
> 	Flags: bus master, fast devsel, latency 0, IRQ 16
> 	I/O ports at ec00 [size=256]
> 	Memory at fc8fc000 (64-bit, non-prefetchable) [size=16K]
> 	Memory at fc8e0000 (64-bit, non-prefetchable) [size=64K]
> 	Expansion ROM at fc900000 [disabled] [size=1M]
> 	Capabilities: [50] Power Management version 2
> 	Capabilities: [68] Express Endpoint IRQ 0
> 	Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
> 	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
> 
> Stay tuned.
> 
> Ciao
> Max

-- 
	Follow the white penguin.
