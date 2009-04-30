Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbZD3SMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbZD3SMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZD3SMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:12:36 -0400
Received: from blaine.gmane.org ([80.91.229.8]:37014 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbZD3SMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:12:35 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: reinette chatre 
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>
Cc: Andreas Schwab 
	<public-schwab-Td1EMuHUCqxL1ZNQvxDV9g@hugh.gmane.org>,
       "linux-wireless-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "linux-kernel-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "netdev-MogPR669STc76Z2rM5mHXA\@public.gmane.org" 
	<public-netdev-MogPR669STc76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
References: <m24ow6vah1.fsf@igel.home> <1241112119.10498.11.camel@rc-desk>
X-Yow: I want to so HAPPY, the VEINS in my neck STAND OUT!!
Date: Thu, 30 Apr 2009 19:27:37 +0200
In-Reply-To: <1241112119.10498.11.camel@rc-desk> (reinette chatre's message of
	"Thu, 30 Apr 2009 10:21:59 -0700")
Message-ID: <m24ow6xd9y.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



reinette chatre
<reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> On Thu, 2009-04-30 at 00:58 -0700, Andreas Schwab wrote:
>> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
>> this build error:
>> 
>> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error: __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
>> 
>> Signed-off-by: Andreas Schwab <schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
>> ---
>> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
>
>>From which repo is this commit id? 

That's from davem/net-2.6 or linville/wireless-2.6.git

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

