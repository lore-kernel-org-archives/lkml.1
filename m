Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbYELCfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbYELCfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYELCey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:34:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYELCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:34:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EtraZfNosEOW2Qv/qEONgSo2yXeDMWaB87Ujlkpb8FNN7BqBKg7wbUMybpvJQP5XB
	e+yA9DLRk8jX9lQEq9biA==
Message-ID: <6599ad830805111934r122f0f5cy302362a21311e4c5@mail.gmail.com>
Date: Sun, 11 May 2008 19:34:48 -0700
From: "Paul Menage" <menage@google.com>
To: "Mirco Tischler" <mt-ml@gmx.de>
Subject: Re: [Patch]: Cgroups: Fix compile warning: incompatible types in kernel/sched.c on 2.6.26-rc1
Cc: "Ingo Molnar" <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1210558353.29885.12.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210558353.29885.12.camel@mtlp.tischlernetz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 7:12 PM, Mirco Tischler <mt-ml@gmx.de> wrote:
> Hi
> I've got this warning on 2.6.26-rc1 on compile:
>> CC      kernel/sched.o
>> kernel/sched.c:9026: warning: initialization from incompatible pointer type
>>
> This patch fixes it.
>
> Thanks
> Mirco
>
> Cgroups: Fix compile warning: incompatible types in kernel/sched.c
>
> Return type of cpu_rt_runtime_write() should be int instead of ssize_t.
>
> Signed-off-by: Mirco Tischler <mt-ml@gmx.de>

Acked-by: Paul Menage <menage@google.com>

Thanks.

Paul
