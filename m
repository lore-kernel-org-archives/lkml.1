Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZAEWbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZAEWbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbZAEWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:31:16 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZAEWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:31:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=KEsoJgH4b72A5IFkXJTzN8eEDJ9Yk7euymlvP1Qnc9e+7cVCYgVEh/l6golXP0hSk
	pFmqdL57rKiy1CZNneL0g==
MIME-Version: 1.0
In-Reply-To: <20090105010726.c0433fea.akpm@linux-foundation.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090105010726.c0433fea.akpm@linux-foundation.org>
Date: Mon, 5 Jan 2009 14:31:08 -0800
Message-ID: <604427e00901051431r7c53704cj46c3b16c7d04d548@mail.gmail.com>
Subject: Re: 2.6.29 -mm merge plans
From: Ying Han <yinghan@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>,
       Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently looking into this by trying to reproduce the issue. I
will update the progress later in the thread.

thanks

--Ying

On Mon, Jan 5, 2009 at 1:07 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> (cc's added)
>
> On Mon,  5 Jan 2009 18:00:33 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> > #
>> > page_fault-retry-with-nopage_retry.patch
>> > page_fault-retry-with-nopage_retry-fix.patch
>> > page_fault-retry-with-nopage_retry-fix-fix.patch
>>
>> I oppose this.
>>
>> Valdis.Kletnieks@vt.edu reported this patch has bug in
>> "28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
>> thread.
>>
>> Nobody answer his question yet.
>
> OK, thanks.  I actually thought we'd fixed that?
>
