Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYAEEt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYAEEt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 23:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYAEEtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 23:49:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:49164 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYAEEtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 23:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JXpNK2/e4AWLEh7H5DFkjKX8o8z4IfgfaCzr7I3GFFOSAji3uL7oqcyzP0hkegZvj6xH5/HC0TNxgPwnGnv2oHIVl+Lho5KGNOuFlBJeZStAeWWsnTQSRpbWMPlgs753o6TlisImZyyJjh+rnwextvcx/mQ1apfRaEucvqzM/Fo=
Message-ID: <477F0BE8.60307@gmail.com>
Date: Sat, 05 Jan 2008 07:47:36 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>,
       Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int>
In-Reply-To: <20080105041228.GP3351@webber.adilger.int>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger пишет:
> On Jan 04, 2008  14:41 +0100, Richard Knutsson wrote:
>>>  @@ -54,6 +54,6 @@ int __ext4_journal_dirty_metadata(const char *where,
>>>  {
>>>  	int err = jbd2_journal_dirty_metadata(handle, bh);
>>>  	if (err)
>>> -		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
>>> +		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle, err);
>>>  	return err;
>>>  }
>> What about changing the __FUNCTION__ to __func__, while you are at it?
> 
> What's wrong with __FUNCTION__?  I thought that was ANSI C?

No, it was not. The ANSI C 1990 Standard defines the following so-called
"predefined macros": __LINE__, __FILE__, __DATE__, __TIME__, and __STDC__.
The ISO/IEC 9899 Standard commonly referred to as the C99, defines a few
additional predefined macros, as well as an additional predefined
identifier __func__. For more information please refer to the ISO/IEC 9899
document itself, which is freely available for download at the time of
me writing this.

Although seemingly "natural", the __FUNCTION__ macro has never been part
of the C Standard.

Dmitri

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

