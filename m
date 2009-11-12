Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZKLLdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZKLLdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZKLLdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:33:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbZKLLdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:33:54 -0500
Date: Thu, 12 Nov 2009 12:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091112113343.GA1386@elte.hu>
References: <1257192496.5941.8.camel@dimm>
 <20091105153742.GA18592@alberich.amd.com>
 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
 <20091106123403.GB18592@alberich.amd.com>
 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
 <20091106194626.GC18592@alberich.amd.com>
 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
 <20091111193832.GG18592@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111193832.GG18592@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing found the following bug - there's a _long_ boot delay of 
58.6 seconds if the CPU family is not supported:

[    1.421761] calling  microcode_init+0x0/0x137 @ 1                                        
[    1.426532] platform microcode: firmware: requesting amd-ucode/microcode_amd.bin         
[   61.433126] microcode: failed to load file amd-ucode/microcode_amd.bin                   
[   61.439682] microcode: CPU0: AMD CPU family 0xf not supported                            
[   61.445441] microcode: CPU1: AMD CPU family 0xf not supported                            
[   61.451273] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba    
[   61.459116] initcall microcode_init+0x0/0x137 returned 0 after 58625622 usecs            

Where does this delay come from?

	Ingo
