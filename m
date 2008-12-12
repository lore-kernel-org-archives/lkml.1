Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYLLJk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYLLJk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYLLJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:40:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:16138 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYLLJkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WfjW7pCM5UfFmowY6LEdtLZmFI8ECYkZMW9WGqpKMByo3CSbpK5WjmSCM+LDT/Cedy
         d6sme/mGh935aQfbRztvc1cT/v6QsjDUvsMrUdV0F3SsCoUuH5rUyyI1a85/KV0VFZyO
         i0GUcfMtiX4lQUodWTvqrIa/ALrYNXFA/PpGI=
Message-ID: <e9e943910812120140j356d9e1g972dfddbb4f14369@mail.gmail.com>
Date: Fri, 12 Dec 2008 09:40:43 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Boaz Harrosh" <bharrosh@panasas.com>, sct@redhat.com, adilger@sun.com,
       linux-ext4@vger.kernel.org
In-Reply-To: <20081211193228.51c34114.akpm@linux-foundation.org>
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
X-Google-Sender-Auth: 4b7ba66d0cd627c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/12 Andrew Morton <akpm@linux-foundation.org>:
> Really?  The ext2 on-disk format requires that the fast symlink be
> null-terminated on disk?  Even though the length is already in i_size?
>
> It seems that's true.  How un-ext2-like.
>
> ext2 and ext4 need the same fix, yes?

Yes. I've sent them out already, but thanks to a monumental cock-up
with the CCs they may not have made it to the list. I'll check and
resend to real addresses if necessary.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
