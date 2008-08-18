Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbYHRHAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbYHRHAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYHRHAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:00:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:44360 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYHRHAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=akKfbvIcdFMQ8btYb5maIQ6FEYR9/CAew68CSszEot4hG2Tnt8qq9tiyGE0Lchnm/C
         ucq0Invab/kYkEo+1DTvRECc052ks1Urd04Btap/kvYwuJjl9xHh0fJdMpUae9vRDWfZ
         DNvdSdQUojNKWFBcnl6U6/tgI8eYfcMI30hIA=
Message-ID: <48A91E12.1060901@gmail.com>
Date: Mon, 18 Aug 2008 09:00:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Subject: ath5k text [Was: pull request: wireless-2.6 2008-08-17]
References: <20080817185605.GC30679@tuxdriver.com> <20080817.151251.204370966.davem@davemloft.net>
In-Reply-To: <20080817.151251.204370966.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2008 12:12 AM, David Miller wrote:
> Their commit messages reference SHA IDs but do not give a commit
> header line text reference as well.
> 
>       ath5k: Don't fiddle with MSI on suspend/resume.

John, this is it (even if I don't understand the purpose):

ath5k: Don't fiddle with MSI on suspend/resume.

Commit 256b152b005e319f985f50f2a910a75ba0def74f (ath5k: don't enable
MSI, we cannot handle it yet) has removed msi support, but overlooked
the suspend/resume code. This patch completes msi removal.

I don't consider this patch copyrightable, and thus put it into the
public domain. The result is of course a base.c file dual-licensed under
3-clause-BSD and GPL.
