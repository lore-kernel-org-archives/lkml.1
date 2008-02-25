Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYBYUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYBYUua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYBYUuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:50:18 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:38394 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBYUuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:50:16 -0500
Date: Mon, 25 Feb 2008 21:49:51 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080225204951.GB4432@ics.muni.cz>
References: <20080225093914.GB4375@ics.muni.cz> <200802251247.30605.rjw@sisk.pl> <20080225200354.GE16513@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225200354.GE16513@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 25 Feb 2008 21:49:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 05:03:54PM -0300, Henrique de Moraes Holschuh wrote:
> This commit is indeed broken, and I have a tentative fix for it.  But I'd
> like to have a better description of just "how" the thinkpad keys do not
> work anymore, to make sure I fix the entire breakage in one go.  I will
> stare at the code and the fix a bit more before sending in any patches,
> though.

Well, keys generate ACPI interrupt but acpid never receives any event.

I would be happy to test fixes to see whether things go well.

-- 
Luká¹ Hejtmánek
