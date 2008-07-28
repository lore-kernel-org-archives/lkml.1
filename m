Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYG1RT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYG1RT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYG1RTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:19:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:60462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbYG1RTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oY7ZDSOCFi8wZWL3cmASAkMwRWq5ts0ozCiqRzHnnJhZQq81XmSgwwYaXcywfJ7swc
         xTFmD8e8aQFRCg5nhaoTdwSmP90GI83t3wqkreCG4uELsnuACehYfEEJeS+mJ91MXVEs
         G+MOPPUvdU4eHuPSz/iLRok76wvadFt+H4v98=
Message-ID: <488DFFB0.1090107@gmail.com>
Date: Mon, 28 Jul 2008 19:19:44 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
References: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org> <488DF119.2000004@gmail.com> <20080729012656.566F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080729012656.566F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> yep! clear.
>>
>> Ok, in this case wouldn't be better at least to define pud_free() as:
>>
>> static inline pud_free(struct mm_struct *mm, pmd_t *pmd)
>> {
>> }
> 
> I also like this :)

ok, a simpler patch using the inline function will follow.

-Andrea
