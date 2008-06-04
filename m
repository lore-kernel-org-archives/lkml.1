Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYFDJ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYFDJ60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYFDJ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:58:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYFDJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:58:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HvSgs5Qj4rGMFQ5FKD8VFGURzatjBzBfQUt6+BKYFuYE5slC+BorxzBEme2e2nyLe
	ZJHLl4oD/zinvtGKVSL6Q==
Message-ID: <6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:58:09 -0700
From: "Paul Menage" <menage@google.com>
To: miaox@cn.fujitsu.com
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and mems_allowed after CPU/NODE offline/online
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>, "David Rientjes" <rientjes@google.com>
In-Reply-To: <6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4845F864.8060102@cn.fujitsu.com>
	 <6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 2:30 AM, Paul Menage <menage@google.com> wrote:
> On Tue, Jun 3, 2008 at 7:05 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>
>> Maybe we need to add a flag in the task_struct to mark which task can't be
>> unbound?
>
> Yes, something like a PF_CPU_BOUND flag that gets set in
> kthread_bind() and checked for in set_cpus_allowed() would be the
> right way to handle that. We have an internal change like that against
> an older kernel verison - I'll see if I can find someone to forward
> port it and send it in.

And in fact they already did, and sent it to lkml a few months ago:

   http://marc.info/?l=linux-kernel&m=120419372032623

Paul
