Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZFBQTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZFBQTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFBQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:19:43 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:46358 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZFBQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AxwrCNL1d5e7Vg0Rq7MPkS5HqNytA7Gh2fz5gMarRwzEM9QcQGGepEwrraTGdZgZ9c
         KVfPEGf2ZtpxXfUr/Cr3+pXn0G3F+2bpyXCIdN1SWRnhWYxOdDurzdUsOo4E7TAh6IOK
         MGAKydQ7hLPTPZIDg+fIWPvwMB9oK4HcFryY4=
MIME-Version: 1.0
In-Reply-To: <20090602155833.GA23657@alberich.amd.com>
References: <20090529184023.GD23770@alberich.amd.com>
	 <20090529184225.GE23770@alberich.amd.com>
	 <36ca99e90906020805r6a4e30br6bb53aeafe5f3cd7@mail.gmail.com>
	 <20090602155833.GA23657@alberich.amd.com>
Date: Tue, 2 Jun 2009 18:19:44 +0200
Message-ID: <36ca99e90906020919r6f700b45p792c179658555cce@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: provide CPU topology information for multi-node 
	processors
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 17:58, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Tue, Jun 02, 2009 at 05:05:07PM +0200, Bert Wesarg wrote:
>> On Fri, May 29, 2009 at 20:42, Andreas Herrmann
>> <andreas.herrmann3@amd.com> wrote:
>> > This support can be switched off/on using a new config option
>> > MULTI_NODE_CPU. If the option is set the CPU topology information is
>> > extended with cpu_node information. This includes a cpu_node_id,
>> > cpu_node_siblings and cpu_node_siblings_list.
>
>> I think this would be a step back after commit
>> c50cbb05a05cf1f9ca3592272eff053c847727d8. Which exported default
>> topology information, in case the architecture does not provide these
>> information.
>
> I am fine with exporting default topology information for all
> architectures.
>
> I just wanted to avoid pollution of sysfs with useless information
> when this information is not provided on an architecture.
>
> Further thoughts -- e.g. concerning the MULTI_NODE_CPU config option?
>
> If I provide defaults for cpu_node_id, cpu_node_siblings etc. the
> config option becomes rather useless and I'll remove it.
Exactly ;-)

The interface to the exported API should not depend on config options.
Only the kernel version number should indicate, whether the cpu_node
information is available or not.

Thanks,
Bert
>
>
> Regards,
> Andreas
>
>
>
