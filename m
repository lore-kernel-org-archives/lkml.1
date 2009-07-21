Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZGUUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZGUUDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZGUUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:03:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12211 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZGUUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:03:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZtuoLebZaHPQxGbu3M3HKDxMbmdFQBFE/Vhk7clyNpTyhOvV3OSXxwZfLJktqSEYk
	WDMACLoMeGQT7Vfhpmilw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907211258500.10356@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
	 <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
	 <20090721161319.2ABD.A69D9226@jp.fujitsu.com>
	 <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
	 <alpine.DEB.2.00.0907211250530.10356@chino.kir.corp.google.com>
	 <6599ad830907211257m6c8d6123g7b36d879913367a0@mail.gmail.com>
	 <alpine.DEB.2.00.0907211258500.10356@chino.kir.corp.google.com>
Date: Tue, 21 Jul 2009 13:03:18 -0700
Message-ID: <6599ad830907211303m25141938kcb75065a74a40ee2@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 1:00 PM, David Rientjes<rientjes@google.com> wrote:
> On Tue, 21 Jul 2009, Paul Menage wrote:
>
>> Agreed, but the same livelock can be fixed in ways that don't break
>> the API. (E.g. check for the victim being OOM_DISABLED in
>> select_bad_process() when we find a new "worst" candidate).
>>
>
> And allow /proc/pid-of-child/oom_score to represent a possible candidate
> (and, additionally, a hint at the oom killing priority) when it really
> isn't?
>

It's the API that's existed for years with no complaints, AFAICS.

Paul
