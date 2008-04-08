Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYDHWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYDHWDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYDHWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:02:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:15245 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYDHWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VqJStbdCD878oe/Wp1jJIDQwbB4J/4Ur2/KalKK1m3ggWxq4Dbm2boNc/3IjiNBN2eI4TthtXzVYEtKb9TCllnQflemGxLru61C6Hp8wT95Cahf/G20esCFmLxgfAtGHnOW3JQ2UMNR1NbrpB2tI3r5VLj2tgCcE3reUqaw+SPw=
Message-ID: <47FBEB7E.2070109@gmail.com>
Date: Wed, 09 Apr 2008 00:02:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in	ieee80211_sta_expire
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com> <1207664966.14253.26.camel@johannes.berg>
In-Reply-To: <1207664966.14253.26.camel@johannes.berg>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2008 04:29 PM, Johannes Berg wrote:
>> ieee80211_sta_expire grabs local->sta_lock and calls sta_info_unlink
>> which tries to grab the lock again. (make available) and use
>> __sta_info_unlink variant instead.
> 
> A patch equivalent to this should already be in.

Yeah, it is. I already replied to myself after getting to know about 
wireless-testing, but forgot to click "send". Thanks.
