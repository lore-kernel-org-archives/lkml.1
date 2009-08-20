Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZHTEtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZHTEtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZHTEty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:49:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZHTEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:49:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XiI+Q5QxrFPgJQMth2QYjZI+9UN0wZc8ZSp9D2k63NQJvMUNMLQlRcQKK0HjZbSFT
	0uVHMsORkh+PZ0XnPi1kg==
MIME-Version: 1.0
In-Reply-To: <20090820044059.GE29801@count0.beaverton.ibm.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
	 <4A8CB62F.8030504@cn.fujitsu.com>
	 <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>
	 <4A8CBEDC.6010709@cn.fujitsu.com>
	 <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
	 <20090820044059.GE29801@count0.beaverton.ibm.com>
Date: Wed, 19 Aug 2009 21:49:51 -0700
Message-ID: <6599ad830908192149o4dc4d4a2p32fbce972a949d0e@mail.gmail.com>
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, bblum@andrew.cmu.edu,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 9:40 PM, Matt Helsley<matthltc@us.ibm.com> wrote:
> On Wed, Aug 19, 2009 at 08:13:59PM -0700, Paul Menage wrote:
>> On Wed, Aug 19, 2009 at 8:11 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> >
>> > As you said, the 2 patches differ just in using different var/func
>> > names, so rebasing shouldn't be hard but maybe a bit boring.
>> >
>>
>> Yes - it's a fair amount of work for no real gain.
>
> So this revert won't introduce a regression for any potential tests?
>

Yes, there would be a two-commit window where a hypothetical test that
tests for concurrent opens of "tasks" files from different pid
namespaces would fail.

If that was really a big deal, then it wouldn't be too hard to fold
the first three patches in this series down into one, but that would
reduce the clarity of the commit history.

Paul
