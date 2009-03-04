Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZCDOra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZCDOra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZCDOrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:47:21 -0500
Received: from mail.polezero.com ([216.68.55.34]:37942 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752420AbZCDOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:47:20 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903041436210.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
	 <1236107096.7793.1.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>
	 <1236172544.21288.3.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz>
	 <1236173654.21288.8.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041436210.4971@jikos.suse.cz>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 09:47:11 -0500
Message-Id: <1236178031.9121.6.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a minor tweak. Please include in the official patch.
(BTN_2 and BTN_3, are not very useful xev doesn't even see them)

-       case 0x01: ks_map_key(BTN_2);   break;
-       case 0x02: ks_map_key(BTN_3);   break;
+       case 0x01: ks_map_key(BTN_MIDDLE);   break;
+       case 0x02: ks_map_key(BTN_SIDE);   break;

Other than that, it works great!

You are awesome, thank you very very much!!


P.S.
I think the failed patch issues were caused by email eating the code
format. Manually editing the failed patch files worked.

On Wed, 2009-03-04 at 14:37 +0100, Jiri Kosina wrote:
> On Wed, 4 Mar 2009, Jason Noble wrote:
> 
> > Sorry to be such a bother.
> > Attached .rej files if they help.
> > 
> > clean just untared 2.6.28.7
> > 
> > patching file a/drivers/hid/Kconfig
> > Hunk #1 succeeded at 157 with fuzz 2.
> > patching file a/drivers/hid/Makefile
> > Hunk #1 FAILED at 30.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/Makefile.rej
> > patching file a/drivers/hid/hid-core.c
> > Hunk #1 FAILED at 1271.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/hid-core.c.rej
> > patching file a/drivers/hid/hid-dummy.c
> > Hunk #1 succeeded at 34 with fuzz 2.
> > patching file a/drivers/hid/hid-ids.h
> > Hunk #1 FAILED at 279.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/hid-ids.h.rej
> > patching file b/drivers/hid/hid-kensington.c
> > paradox:/usr/src# ls a/drivers/hid/Makefile.rej 
> > a/drivers/hid/Makefile.rej
> 
> Odd, the patch I sent you was based on 2.6.28.7.
> 
> You can just add the lines from .rej files manually, it's only 6 lines of 
> code or so.
> 

