Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYGNBWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYGNBWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 21:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYGNBWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 21:22:13 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33932 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbYGNBWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 21:22:12 -0400
X-Sasl-enc: GVruIE8cytF+0OGZrA2mL5COiIP4DrN86iX+scIEj4BA 1215998530
Date: Sun, 13 Jul 2008 22:22:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080714012206.GA11882@khazad-dum.debian.net>
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <487A62B3.8010207@zytor.com> <487A63D2.9040006@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487A63D2.9040006@firstfloor.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Andi Kleen wrote:
> It probably switches to protected mode. I noticed this on my old
> Fujitsu laptop when I tried to make the S3 wakeup run in the s2ram x86 emulator
> and found it entered protected mode at some point, which x86emu
> didn't support.
> 
> I guess Lenovo is doing the same.
> 
> And that protected mode code relies on some GDT values that have been
> loaded earlier when the BIOS also went into protected mode.
> 
> It seems the BIOS programmers really don't like real mode anymore.
> Somehow understandable.

If it were just Lenovo, it shouldn't be too difficult to get them to fix the
BIOS.  But since other vendors have the same problem, that won't fly as a
solution.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
