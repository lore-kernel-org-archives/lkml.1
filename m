Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYLDXCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYLDXCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYLDXCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:02:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYLDXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:02:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=tdGQKV2iataeB4JRDIt5/ztMS22kFI17taSO9C+ycQ43Rcf7rHvLXdfV3SXexl9wa
	+PjAPIqlM1EKjmholeIbA==
MIME-Version: 1.0
In-Reply-To: <49376BE3.1040909@cn.fujitsu.com>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	 <49376BE3.1040909@cn.fujitsu.com>
Date: Thu, 4 Dec 2008 15:02:31 -0800
Message-ID: <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
Subject: Re: [patch] export percpu cpuacct cgroup stats
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 9:34 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +
>>  static struct cftype files[] = {
>>       {
>>               .name = "usage",
>>               .read_u64 = cpuusage_read,
>>               .write_u64 = cpuusage_write,
>>       },
>> +     {
>> +             .name = "percpu",
>
> IMO percpu_usage is a better name.
>

Maybe usage_percpu ?

That fits in with the style used in e.g. memory.limit_in_bytes where
the first word is the important quantity, and the subsequent words
indicate some aspect of the quantity.

Paul
