Return-Path: <linux-kernel-owner+w=401wt.eu-S934388AbYBNAO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388AbYBNAO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbYBNAOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:14:25 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:37332 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbYBNAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:14:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XPvAOnldkeBTZRWwqsxZ9qYAJ/NaTXfKBBCJTSPKXkzz4rxTTi9AHaWZjYpTVN8JkNh5lRN2zWiEYNeP3QVEWKJpFj51E1Pe1VJkvi/CibsoyxssC5/mWwHFylCLb+RNGpVWTdqFSnOpvKkXQ6pXzsqJsWdaQYjd5GlvVH8inxA=
Message-ID: <47B387D2.5050808@gmail.com>
Date: Thu, 14 Feb 2008 09:14:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: implement printk_buf overflow warning
References: <47B2B250.8020209@gmail.com> <20080213155954.c1d0b6ee.akpm@linux-foundation.org>
In-Reply-To: <20080213155954.c1d0b6ee.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 Feb 2008 18:03:12 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> printk silently truncates messages longer than 1024 - 1 bytes.
>> Implement overflow detection and append "$PRINTK_BUF_OVERFLOW$\n" to
>> truncated messages.
> 
> I don't think I've ever heard of anyone managing to overflow the printk
> buffer and it's hard to imagine how a sane person could manage to do this.
> 
> I assume this is happening because of changes in your other patchset, and
> that this change is hence associated with those changes and should probably
> be a part of the same patch series?

I thought this went well with the recursion warning.  I'll move it into
the mprintk patchset.

Thanks.

-- 
tejun
