Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbZHJF13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbZHJF13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 01:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZHJF12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 01:27:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43295 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZHJF11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 01:27:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A7FAF8E.3060007@jp.fujitsu.com>
Date: Mon, 10 Aug 2009 14:26:38 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, mce: therm_throt - change when we print messages
References: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> My Latitude d630 seems to be handling thermal events in SMI by lowering
> the max frequency of the CPU till it cools down but still leaks the
> "everything is normal" events. Adjust therm_throt driver to only print
> messages about the fact that temperatire returned back to normal when
> leaving the throttling state.
> 
> Also lower the severity of "back to normal" message from KERN_CRIT to
> KERN_INFO.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---

Looks good.  Thank you for providing nicer logic!

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

