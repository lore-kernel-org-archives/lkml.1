Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZL2Coe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZL2Coe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 21:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZL2Cod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 21:44:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:45908 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZL2Coc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 21:44:32 -0500
Message-ID: <4B396CA7.6070701@vflare.org>
Date: Tue, 29 Dec 2009 08:12:47 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Yin Kangkai <kernel@holddreams.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [mmotm] ramzswap: add handlers for various swap	events
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <1261963200-7136-2-git-send-email-ngupta@vflare.org> <20091228162648.GA29309@kai-nas>
In-Reply-To: <20091228162648.GA29309@kai-nas>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2009 09:56 PM, Yin Kangkai wrote:
> On 2009-12-28, 06:50 +0530, Nitin Gupta wrote:
>> +	ret = register_swap_event_notifier(&ramzswap_swapon_nb,
>> +				SWAP_EVENT_SWAPON, 0);
>> +	if (ret) {
>> +		pr_err("Error registering swapon notifier\n");
>> +		goto out;
>> +	}
>> +
>> +	ret = register_swap_event_notifier(&ramzswap_swapoff_nb,
>> +				SWAP_EVENT_SWAPOFF, 0);
>> +	if (ret) {
> 
> Sorry, but an unregister here?

Oh, I missed it. I will add it in next patch revision.

Thanks,
Nitin
