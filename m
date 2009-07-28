Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZG1Ark@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZG1Ark (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZG1Arj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:47:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63158 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG1Arj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:47:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iBzN2f8ECK62HuDQkjWi0FgnWGJ7ERHcgTM7Exqy9D7p5Agv9Wo7F2NEPHUOdjLy5
	eTXpAq1J+iYECSx62THYg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907271739230.29815@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com>
	 <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com>
	 <alpine.DEB.2.00.0907271658550.27881@chino.kir.corp.google.com>
	 <6599ad830907271730y2f783042q87e1bed5d7130550@mail.gmail.com>
	 <alpine.DEB.2.00.0907271739230.29815@chino.kir.corp.google.com>
Date: Mon, 27 Jul 2009 17:47:35 -0700
Message-ID: <6599ad830907271747v578fb78cna2d43856f8fba7c@mail.gmail.com>
Subject: Re: [patch -mmotm] mm: introduce oom_adj_child
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 5:45 PM, David Rientjes<rientjes@google.com> wrote:
> On Mon, 27 Jul 2009, Paul Menage wrote:
>
>> > Ok, we can allow oom_adj_child to be less than oom_adj for
>> > CAP_SYS_RESOURCE.
>>
>> Sounds fine to me, since you already need CAP_SYS_RESOURCE to set
>> oom_adj anyway. But actually, shouldn't you just be requiring
>> CAP_SYS_RESOURCE to set oom_adj_child at all?
>>
>
> Tasks can elevate their own oom_adj value without that capability.

OK, I see that changed since 2.6.18.

Paul
