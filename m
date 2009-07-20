Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZGTV3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZGTV3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZGTV3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:29:01 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48500 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZGTV3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=F/49w58qJl4TvxERNFYmJvByqIAZ3GgJMJmgsUj5uIWP9qbmG7NK/lY38RCRCs80YM
         nW72uRSRL6d7sfIlFsUIuO2XON3qbS/shiRt1/Tl6EB8ZI5Tcwx0LYNpF9emWk1n3UFd
         rbWwTQ2Hq6RXTGk4UK6Ph11blihSkAhT1jQDo=
Message-ID: <4A64E199.70501@gmail.com>
Date: Mon, 20 Jul 2009 23:28:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linville@tuxdriver.com, luciano.coelho@nokia.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com> <87eish56zj.fsf@litku.valot.fi>
In-Reply-To: <87eish56zj.fsf@litku.valot.fi>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 11:09 AM, Kalle Valo wrote:
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c |    2 +-
> 
> Unfortunately this won't apply to wireless-testing because main.c is
> renamed to wl1251_main.c.
> Can you respin the patch or do you want me to
> do it? I'm sending other wl12xx patches anyway and it's easy for me to
> rebase this one at the same time.

It seems to be fixed now. But currently I'm confused by wl1251_plt_start
and wl1251_plt_stop. They take a lock but doesn't unlock it at all.
Neither their callies. Is it hidden somewhere deeper?
