Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYJVOTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYJVOTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYJVOTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:19:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:59525 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYJVOTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YvRj9X2Qa1+RaSrUIjPPrESp9P+5099JSWvWtEr+4uC1/Lu6Nq1+b5A5+9cg+m54oG
         kzURRlklCWDPYuQ2McrUsQAQf6gScX4Ahgx5I6QfUjX8ZhNkY9DiR2wZwNolgW0eOjxF
         ev8s0EYpWvNUzJ+/jKRoRAwvNncv0scPDOoBo=
Message-ID: <48FF3676.1060909@gmail.com>
Date: Wed, 22 Oct 2008 16:19:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Gregory Nietsky <gregory@dnstelecom.co.za>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1] Ath5k: add AP mode
References: <1223844850-26551-1-git-send-email-jirislaby@gmail.com> <40f31dec0810211108l6700d806o4804b43d9fe47bf7@mail.gmail.com>
In-Reply-To: <40f31dec0810211108l6700d806o4804b43d9fe47bf7@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2008 08:08 PM, Nick Kossifidis wrote:
> 2008/10/12 Jiri Slaby <jirislaby@gmail.com>:
>> Add support for AP mode. This involves:
>> - enablement in ath5k_beacon_config -- initialize beacon timer
>> - add AP to the supported modes in ath5k_add_interface
>> - handle beacon change even for AP in ath5k_config_interface
>> - remove useless test for IBSS in ath5k_beacon_update
>>
>> Note that it doesn't enable the AP mode for the driver. It must
>> be enabled by NL80211_IFTYPE_AP bit added to interface_modes.
[...]
> a) It won't work without the following as Gregory pointed out

This was intentional, see the changelog.

> b) For some reason it only works with 5212/5213 cards, i tested it on
> a 5413 and an 2425 and it didn't work (hostapd seems to hang).

I've ordered 5413 ;), will come with updates.

Thanks for testing, Nick.
