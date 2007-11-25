Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXKYOlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXKYOlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 09:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXKYOkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 09:40:55 -0500
Received: from quechua.inka.de ([193.197.184.2]:59358 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXKYOkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 09:40:55 -0500
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2007 09:40:55 EST
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Documentation about unaligned memory access
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Organization: private Linux site, southern Germany
From: Olaf Titz <olaf@bigred.inka.de>
Date: Sun, 25 Nov 2007 15:13:48 +0100
Message-ID: <E1IwIF2-0003eP-GH@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unaligned memory accesses occur when you try to read N bytes of data starting
> from an address that is not evenly divisible by N (i.e. addr % N != 0).

Should clarify that you mean "with power-of-two N" - even more
strictly this depends on the processor, but I'm pretty sure there is
none which supports aligned accesses of N==3...

Olaf
