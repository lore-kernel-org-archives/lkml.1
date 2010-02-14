Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab0BNPrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 10:47:13 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43921 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0BNPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 10:47:12 -0500
Date: Sun, 14 Feb 2010 16:47:10 +0100
From: Andreas Mohr <andi@lisas.de>
To: Erik Andren <erik.andren@gmail.com>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop
	to the DMI whitelist
Message-ID: <20100214154709.GA7271@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Latitude C640 has another variation of dell in its DMI vendor entry.
> Add it to the whitelist in order to enjoy the sweet fruits of software
> backlight toggling.

Definitely not only this one. E.g. my Inspiron 8000 (P3/700) has (dmidecode):

Handle 0x0300, DMI type 3, 13 bytes
Chassis Information
        Manufacturer: Dell Computer Corporation
        Type: Portable

which, if "Portable" happens to be "8", means that it would match.

So:
- do all older matching machines grok this?
- if not, do something about it? ;)

[I should probably just offer myself to be a guinea pig]

Thanks for a very interesting piece of work!

Andreas Mohr
