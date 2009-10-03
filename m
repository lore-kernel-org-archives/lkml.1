Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZJCTQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZJCTQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 15:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZJCTQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 15:16:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbZJCTQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 15:16:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=pw/t5rKhCLAF7unrMrq+YXyZs+0hhZqxwjaNmiPTUcZYz/u66KWbnQJVljd/BNCXO
	KYyuS825Y2rKnfKxL89TQ==
MIME-Version: 1.0
In-Reply-To: <2f11576a0910030505w5a1289ebu78cdc3587caddc82@mail.gmail.com>
References: <20091002173635.5F6C.A69D9226@jp.fujitsu.com>
	 <20091002173955.5F72.A69D9226@jp.fujitsu.com>
	 <6599ad830910021501s66cfc108r9a109b84b0f658a4@mail.gmail.com>
	 <2f11576a0910030505w5a1289ebu78cdc3587caddc82@mail.gmail.com>
Date: Sat, 3 Oct 2009 12:15:25 -0700
Message-ID: <6599ad830910031215o293687ceyd8177cb1c34a41b@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroup: fix strstrip() abuse
From: Paul Menage <menage@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 5:05 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Thanks - although I think I'd s/abuse/misuse/ in the description.
>
> I don't know what's different between them. My dictionary is slightly quiet ;)
> Is this X-rated word? if so, I'll resend it soon.

Certainly not X-rated :-)

Generally "abuse" carries a connotation of intent (or perhaps
deliberate hackiness) whereas "misuse" simply indicates that the
previous code was wrong.

Paul
