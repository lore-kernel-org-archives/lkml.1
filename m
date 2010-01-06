Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263Ab0AFUaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0AFUaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032Ab0AFUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:30:36 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57534 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab0AFUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ph4a1MIXAvuVX43yYMY7kMdqxQAYWr1sR/70KYdFwI2kEcBAfvGPGHxABcSororLPT
         c3hut8XPvb3j9ARbqJKyZCkP9x9m08b70oiPi7xgvmqfY4E3A6k3KMMfEQCu72vHEeBG
         12dviCZd9ms75Sytt82nPJg4g8qxbq8cS2XyI=
Message-ID: <4B44F2E4.9010900@gmail.com>
Date: Wed, 06 Jan 2010 21:30:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: wireless, fix lock imbalance
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz> <20100106195503.GB2870@tuxdriver.com>
In-Reply-To: <20100106195503.GB2870@tuxdriver.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 08:55 PM, John W. Linville wrote:
> On Wed, Jan 06, 2010 at 05:35:42PM +0100, Jiri Slaby wrote:
>> One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
>> Fix that.
>>
>> Trigerrable by "Scan for SSID" with long enough SSID (> 32).
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Both this and the next one are already fixed in wireless-2.6...

Ok, thanks.
-- 
js
