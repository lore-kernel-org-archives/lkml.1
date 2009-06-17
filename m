Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZFQJnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZFQJnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbZFQJnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:43:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZFQJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:43:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ujbnwttlOZXBeOE8iWD4v/Udk7QpLdUWraxm+rJyTfw2ljDXa5asISxe0keNsk+yj
	fTjQQS3my44fDGXeHlJDA==
MIME-Version: 1.0
In-Reply-To: <4A383CAB.6060809@cn.fujitsu.com>
References: <200906161646.50305.knikanth@suse.de>
	 <4A383CAB.6060809@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 02:42:58 -0700
Message-ID: <6599ad830906170242v47b56368ra1b39ef2c5bb4a81@mail.gmail.com>
Subject: Re: cpusets: document adding/removing cpus to cpuset elaborately
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 5:45 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Nikanth Karthikesan wrote:
>> Writing a pid to the file, tasks adds that task to that cgroup/cpuset. But to
>> add a cpu/mem to a cpuset, the new list of cpus should be written to the
>> cpuset.mems file which would replace the old list of cpus. Make this clearer
>> in the documentation.
>>
>
> Though I think '>' already means overwrite so removing/adding cpus should
> always writing the full list of CPUs to 'cpus'

But in the context of cgroups/cpusets that's not always the case -
think of the "tasks" file.

>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Paul
