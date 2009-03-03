Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZCCGBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZCCGBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZCCGBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:01:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZCCGBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:01:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=G58bIwNtNw/pp3Iks6o0/PKx3kQ0FkwNOOiohflX36TD7Fy60sylDvP9Nh+oSB6VF
	WhhoihzEv2AhgRqrK8aQA==
MIME-Version: 1.0
In-Reply-To: <49ACA13B.5050106@cn.fujitsu.com>
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
	 <49ACA13B.5050106@cn.fujitsu.com>
Date: Mon, 2 Mar 2009 22:01:14 -0800
Message-ID: <6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 7:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +static int generate_sched_domains(struct cpumask **domains,
>> +                     struct sched_domain_attr **attributes)
>> +{
>
> Except here should "return 0;", otherwise emit a compile warining.
>

Good catch - the weird thing is that (in my UML build) it doesn't
actually generate that warning. Mysterious.

I'll resend with the extra return.

Paul
