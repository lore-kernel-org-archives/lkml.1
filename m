Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYCMHeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYCMHeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYCMHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:33:48 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:39029 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYCMHds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:33:48 -0400
Date: Thu, 13 Mar 2008 08:33:24 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313073324.GB27873@ics.muni.cz>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <200803130830.47709.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803130830.47709.arekm@maven.pl>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 13 Mar 2008 08:33:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 08:30:47AM +0100, Arkadiusz Miskiewicz wrote:
> Mar 13 08:27:48 tarm acpid: received event "ibm/hotkey HKEY 00000080 00001018"
> Mar 13 08:27:48 tarm acpid: notifying client 4071[126:126]
> Mar 13 08:27:48 tarm acpid: notifying client 4096[0:0]
> Mar 13 08:27:48 tarm acpid: notifying client 4230[0:0]
> Mar 13 08:27:48 tarm acpid: completed event "ibm/hotkey HKEY 00000080 
> 00001018"
> (this log was done while X was running + some kde apps).

I got this event under 2.6.25-rc3-git1.

However, I wonder why some keys are reported as key press through input device
and some only for acpid. I thing, all the key should be reported in the same
way...

-- 
Luká¹ Hejtmánek
