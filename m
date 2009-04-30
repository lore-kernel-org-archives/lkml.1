Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbZD3IVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbZD3IVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbZD3IUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:20:21 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46296 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235AbZD3IUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:20:18 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
References: <m24ow6vah1.fsf@igel.home>
	<1241078967.25477.8.camel@johannes.local>
X-Yow: YOW!!  The land of the rising SONY!!
Date: Thu, 30 Apr 2009 10:20:15 +0200
In-Reply-To: <1241078967.25477.8.camel@johannes.local> (Johannes Berg's
	message of "Thu, 30 Apr 2009 10:09:26 +0200")
Message-ID: <m28wlih7sw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-30 at 09:58 +0200, Andreas Schwab wrote:
>> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
>> this build error:
>> 
>> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error:
>> __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
>> 
>> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
>> ---
>> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
>> misattributed as a compiler bug.
>
> At least in my tree the function isn't static...(yet I still got the
> compiler error)?

The static function is iwl3945_rx_queue_free.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
