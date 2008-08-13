Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYHMLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYHMLIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYHMLIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:08:39 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:21019 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbYHMLIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jSQlqV5y5YAtdld8T3MsQ2eDg744/vzWmczLyT4mVr2WlZoiGnAOu+TZNyu7mETYuO
         ZOWdCu2Wz/pIGVwR+xpeB2jqxU/mLQ665DFOcD1Su72oLf7jcsfQ8dJ2o4BJMzQVIITk
         vnwV2wmUNnbEQgl8F4NguF/LviYw1iHLaadXg=
Message-ID: <48A2C0A5.3060404@googlemail.com>
Date: Wed, 13 Aug 2008 12:08:21 +0100
From: Johannes Engel <jcnengel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.12) Gecko/20071114 SUSE/2.0.0.12-34.1 Lightning/0.8 Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 repost #1] DRM: don't enable irqs in locking
References: <1216975369-6749-1-git-send-email-jirislaby@gmail.com>	<21d7e9970807250154q4a1958f5k45f62408e97ae3c7@mail.gmail.com> <488E2CED.1040207@tungstengraphics.com> <48A18EAB.40808@googlemail.com> <48A2984E.5050202@tungstengraphics.com>
In-Reply-To: <48A2984E.5050202@tungstengraphics.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Johannes Engel wrote:
>> Thomas Hellström wrote:
>>> Yes, this bug could occur, but the remedy is not to use 
>>> spin_lock_irqsave() for lock_data::spinlock but to avoid calling 
>>> drm_lock_take with the drm_device::tasklet_lock held with irqs 
>>> disabled.
>>> I'll see if I can come up with a patch.
>> Hi Thomas,
>>
>> any news on that so far?
>>
>> Cheers, Johannes
> Hi!
> Been on vacation.
>
> Pls try the attached patch. 
It works for me. Thanks a lot.
Hope you had pleasant holidays. :)

Cheers, Johannes
