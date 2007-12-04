Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXLDMbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXLDMbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXLDMbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:31:33 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:40621 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXLDMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:31:32 -0500
Date: Tue, 4 Dec 2007 13:31:21 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: Hitachi disk quirk
Message-ID: <20071204123121.GA8704@ics.muni.cz>
References: <20071204104529.GA4098@ics.muni.cz> <47553E8B.303@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47553E8B.303@msgid.tls.msk.ru>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 04 Dec 2007 13:31:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:48:27PM +0300, Michael Tokarev wrote:
> Which problems, exactly?

it is spurious completitions and I saw that because of that the drives are
blacklisted. Moreover, the same drive is already blacklisted but with
different firmware. 
 
> Note that recent massive "NCQ horkage" isn't necessary due to drives fault.
> Search for "spurious completions during NCQ" for recent discussions
> (many of them).
> 
> > --- a/drivers/ata/libata-core.c	2007-12-04 11:08:20.000000000 +0100
> > +++ b/drivers/ata/libata-core.c	2007-12-04 11:09:23.000000000 +0100
> >  	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
> > +	{ "HITACHI HTS541616J9SA00", "SB4IC7UP", ATA_HORKAGE_NONCQ, },
> >  	{ "Hitachi HTS542525K9SA00", "BBFOC31P", ATA_HORKAGE_NONCQ, },
> 
> /mjt

-- 
Luká¹ Hejtmánek
