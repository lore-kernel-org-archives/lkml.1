Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbYBZSuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbYBZSuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYBZStz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:49:55 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:60068 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYBZSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:49:54 -0500
Date: Tue, 26 Feb 2008 19:49:37 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080226184937.GA4280@ics.muni.cz>
References: <20080225093914.GB4375@ics.muni.cz> <200802251247.30605.rjw@sisk.pl> <20080225200354.GE16513@khazad-dum.debian.net> <20080225204951.GB4432@ics.muni.cz> <20080225210113.GF16513@khazad-dum.debian.net> <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225230035.GA14503@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 26 Feb 2008 19:49:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 08:00:35PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 25 Feb 2008, Lukas Hejtmanek wrote:
> > volume keys work. But anything through acpid does not. Even AC/battery switch
> > is not signalized. So the bug may be somewhere else?
> 
> Yeah, there is an EC-related regression in 2.6.25-rc3 that bites your
> thinkpad.  I don't have a link to it right now, but if you look for the
> messages to LKML on the last 48h, you will find it.

this one fixes all my troubles with thinkpad hotkeys in rc3.
http://lkml.org/lkml/2008/2/25/400
 
> > [  418.816087] thinkpad_acpi: requested hot key mask 0xffffffff, but firmware forced it to 0x00ffffff
> 
> Don't do this.  Just let the driver select the default mask, unless you
> *really* know better.

OK, thanks.

-- 
Luká¹ Hejtmánek
