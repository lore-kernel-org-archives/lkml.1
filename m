Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYHAPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYHAPC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYHAPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:02:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYHAPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=yEMSd0/lYQhYJKmpkHrom2yKMaNo2vtEPBJipYZEg5kESnfhf17QQE3Q1ofRI5yGWL
         2sF3baxr7GzAscKNdQcY5ahKYi+14lTnHf8Sj9Sx0kVQhdqEYHODJ0/8nSPJyhaqv2nw
         MZBVfNCccnKFYEDOjyx2IN0Q6fZrZUqAjc5N8=
Message-ID: <4893257C.1020907@gmail.com>
Date: Fri, 01 Aug 2008 17:02:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Young <hidave.darkstar@gmail.com>, johannes@sipsolutions.net,
       tomasw@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linville@tuxdriver.com, stable@kernel.org
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>	 <4892C359.9000304@cs.helsinki.fi>	 <20080801011415.ff4821a3.akpm@linux-foundation.org> <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
In-Reply-To: <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland napsal(a):
> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>>> Jiri Slaby wrote:
>>>> Dave Young napsal(a):
>>>>> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>>>>> sc->lock
>>>> Should be fixed already:
>>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>> I guess that didn't make it to -stable?
>> (cc stable!)
> 
> Not to worry, the commit that introduced it was
> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
> came in after 2.6.26.

git-describe 9d139c810a2aa17365cc548d0cd2a189d8433c65
v2.6.26-rc8-1219-g9d139c8

