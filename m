Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXFRFaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXFRFaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXFRFaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:30:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:46218 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbXFRFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dwFB7TYRueDtD1oCehMRS7z7sqH/juLalBziP4bfRZElBJCyOSBHf95VhlaLtveB2YO7rJxeN1St0er9MW/oKQ6nWbLXfTid6p4XNOcQQ41tEujTx3d5gHBkAbaEEaBj6DTtTDXPPiOReIywCCZ6zKw1zHt/tFdLR6PfYVjTeTQ=
Message-ID: <46761858.7080208@gmail.com>
Date: Mon, 18 Jun 2007 14:30:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Massimiliano Hofer <max@nucleus.it>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florin Iucha <florin@iucha.net>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: spurious completions during NCQ?
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <20070608131157.GH30661@iucha.net> <20070608162802.7d5bc66a@the-village.bc.nu> <200706150951.58586.max@nucleus.it>
In-Reply-To: <200706150951.58586.max@nucleus.it>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Massimiliano Hofer wrote:
> On Friday 8 June 2007, Alan Cox wrote:
> 
>>> 	Model Number:       HITACHI HTS541680J9SA00
>>> 	Serial Number:      SB******I57L4A
>> This one is already blacklisted in the windows drivers.
> 
> I have the same problem with this drive (shipped with a Thinkpad Z61m):
> 
>         Model Number:       HITACHI HTS541612J9SA00
>         Firmware Revision:  SBDIC7JP
> 
> It reported several dozen spurious completions over a few days, but I can't 
> find any corruption. Is it really dangerous? I understand this clearly is a 
> firmware bug, but I'm not sure how to interpret the drive behavior.
> I can perform any test you like, if you find it useful.

It has _slight_ change of being dangerous and is just in violation of
the protocol.  No real data corruption case reported yet tho.  Till now
most drives which report such problems had stinky NCQ implementation
anyway - slow, buggy, blacklisted in the other OS, etc...  I'll submit a
patch to blacklist the drive.

Thanks.

-- 
tejun
