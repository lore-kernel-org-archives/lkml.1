Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYLLKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYLLKTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYLLKTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:19:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:26422 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYLLKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:19:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aizEJXXQ9XV3gtkVOeu+Spd6pN2TJgbmBlpocFSAoi+6QPfFRbIYA1XP1rldf/I9X5
         wU6mc9pp8omLRwf5hMK6esbRV2sBLxcdhdD0DYP0G0Ju+xdzTIO4A/DY/ZSZ99vWaStn
         rK9kV1aFpdjTYq09zj3ZTlIkp/i085p4nh75k=
Message-ID: <e9e943910812120219k54e46330hc82add29a7fda455@mail.gmail.com>
Date: Fri, 12 Dec 2008 10:19:20 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Boaz Harrosh" <bharrosh@panasas.com>, sct@redhat.com, adilger@sun.com,
       linux-ext4@vger.kernel.org
In-Reply-To: <e9e943910812120140j356d9e1g972dfddbb4f14369@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-5-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-6-git-send-email-duaneg@dghda.com>
	 <20081211222605.GB18665@dastardly.home.dghda.com>
	 <20081211193228.51c34114.akpm@linux-foundation.org>
	 <e9e943910812120140j356d9e1g972dfddbb4f14369@mail.gmail.com>
X-Google-Sender-Auth: b8c6c2b414494f2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/12 Duane Griffin <duaneg@dghda.com>:
> 2008/12/12 Andrew Morton <akpm@linux-foundation.org>:
>> Really?  The ext2 on-disk format requires that the fast symlink be
>> null-terminated on disk?  Even though the length is already in i_size?
>>
>> It seems that's true.  How un-ext2-like.
>>
>> ext2 and ext4 need the same fix, yes?
>
> Yes. I've sent them out already, but thanks to a monumental cock-up
> with the CCs they may not have made it to the list. I'll check and
> resend to real addresses if necessary.

Seems they did make it:
http://marc.info/?l=linux-kernel&m=122903437006575&w=2
http://marc.info/?l=linux-kernel&m=122903451306859&w=2

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
