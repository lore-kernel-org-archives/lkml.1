Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYCLThc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYCLThc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYCLThW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:37:22 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:59955 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbYCLThV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:37:21 -0400
Date: Wed, 12 Mar 2008 20:36:37 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080312193637.GA27873@ics.muni.cz>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803121952.42666.arekm@maven.pl>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 12 Mar 2008 20:36:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 07:52:41PM +0100, Arkadiusz Miskiewicz wrote:
> I'm also seeing regression on my thinkpad z60m where with git tree (tested 
> again with 2 days old git) "thinkvantage" button stopped working (pressing it 
> was previously seen by some userspace kde which run konsole).
> 
> On 2.6.24 presses are seen.

well, on 2.6.25-rc4, some keys are not reported as input (xev does not see any
key press), some keys are. Is this desired? Or all the keys (fn+f1-12 + volume
+ backlight + think vantage) should be reported as some input event and thus
acpid makes no sense any more?

-- 
Luká¹ Hejtmánek
