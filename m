Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXLDLsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXLDLsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLDLsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:48:30 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23786 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbXLDLs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:48:29 -0500
Message-ID: <47553E8B.303@msgid.tls.msk.ru>
Date: Tue, 04 Dec 2007 14:48:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: PATCH: Hitachi disk quirk
References: <20071204104529.GA4098@ics.muni.cz>
In-Reply-To: <20071204104529.GA4098@ics.muni.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> the following patch should be applied into 2.6.24-rc3 as the mentioned Hitachi
> disk has also problem with NCQ.

Which problems, exactly?

Note that recent massive "NCQ horkage" isn't necessary due to drives fault.
Search for "spurious completions during NCQ" for recent discussions
(many of them).

> --- a/drivers/ata/libata-core.c	2007-12-04 11:08:20.000000000 +0100
> +++ b/drivers/ata/libata-core.c	2007-12-04 11:09:23.000000000 +0100
>  	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
> +	{ "HITACHI HTS541616J9SA00", "SB4IC7UP", ATA_HORKAGE_NONCQ, },
>  	{ "Hitachi HTS542525K9SA00", "BBFOC31P", ATA_HORKAGE_NONCQ, },

/mjt
