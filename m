Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYI1Pya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYI1Pya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYI1PvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:51:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47042 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYI1PvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J/2ooLp3K5lw3jPVsz1Kdyg0DOjlQeBZsHhzPI7+XdY8FgGVO2dr25yeOByNNBUMkV
         UUJtQRTo0++F0Ddlgv+WN6FhOnrDTfBKakhe1urewKs5q9Sqz2KVHVXZSHXdWg3U7OSP
         avNc0fUS8hQaI/bA7nrwM1JYix9T5jRlqCtAU=
Message-ID: <c384c5ea0809280851j59fe7201yda71b2101f4cb8e2@mail.gmail.com>
Date: Sun, 28 Sep 2008 17:51:07 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scatterlist.c: bug in sg_next()?
In-Reply-To: <48DFA285.1010701@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c384c5ea0809280815l63fab13fqf97a619598f0dd71@mail.gmail.com>
	 <48DFA285.1010701@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 28, 2008 at 5:28 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Leon Woestenberg wrote:
>> In sg_next(), after following a chain_ptr, a few more checks should be
>> performed.
>> The rare case exists that the first entry in the chained list is a
>> last marker, in case NULL must be returned.
>
> No! the last marker is set on a valid sg entry. Only it's next
> is no longer valid. So the check at the top is for the Next-sg
> not the passed-in-sg. What you thought of is a NULL terminating
> sg-list. The end marker is so to save the extra NULL entry.
>
Ah yes, the lower bit magic. Thanks!

Sorry for the noise.

Regards,
-- 
Leon
