Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZA1Dge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZA1Dge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZA1DgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:36:22 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:34975 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZA1DgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WWuSN4t8Et28pZ94C8oQSDzsEYEZUY4kaLZ8njYafSzUrKvz+hMyNSynxwk+ba41Td
         FnEwi7eIk3BqqL93D7+u0bdVgb4RVv51q+tAqIkNL/Xi1kVD97U9WJV8oRs5L838uW3T
         Twr23+FJa3fpH88OUaVe/j/iZcHOAIEeeyYV4=
Message-ID: <497FD2AF.6020801@gmail.com>
Date: Wed, 28 Jan 2009 12:36:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <20090115183942.GA6325@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org> <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org> <20090127131317.GF23121@elte.hu> <497F93A2.404@kernel.org>
In-Reply-To: <497F93A2.404@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Ingo Molnar wrote:
>> * Tejun Heo <tj@kernel.org> wrote:
>>
>>>> Tejun, any chance of you updating the tj-percpu tree? My current 
>>>> patches are against Linus's tree, and rebasing them on yours involves 
>>>> some icky merging.
>>> If Ingo is okay with it, I'm fine with it too.  Unless Ingo objects, 
>>> I'll do it tomorrow-ish (still big holiday here).
>> Sure - but please do it as a clean rebase ontop of latest, not as a 
>> conflict-merge, as i'd expect there to be quite many clashes.
> 
> Alrighty, re-basing.

Okay, rebased on top of the current master[1].

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

The rebased commit ID is e7f538f3d2a6b3a0a632190a7d736730ee10909c.

There were several changes which didn't fit the rebased tree as they
really belong to other branches in the x86 tree.  I'll re-submit them
as patches against the appropriate branch.

Thanks.

-- 
tejun

[1] 5ee810072175042775e39bdd3eaaa68884c27805
