Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZBLB6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZBLB6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZBLB6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:58:16 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZBLB6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:58:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CjcMxel6pBKMMuiOH7yrBUg/CjFCzyZapq/59mfhWv+QX+l7qZJfULcv4VHjYqOtg
	Nq41JYfJZCcehNG81QoPQ==
MIME-Version: 1.0
In-Reply-To: <200902121255.43047.nickpiggin@yahoo.com.au>
References: <4976D77C.3020107@cn.fujitsu.com>
	 <200902121154.02868.nickpiggin@yahoo.com.au>
	 <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
	 <200902121255.43047.nickpiggin@yahoo.com.au>
Date: Wed, 11 Feb 2009 17:58:11 -0800
Message-ID: <6599ad830902111758r140d00c1wf6e757e337a1caa9@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 5:55 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> But if the old and new nodes are disjoint, that could lead to seeing no
>> nodes.
>
> Well we could structure updates as setting all new allowed nodes,
> then clearing newly disallowed ones.
>

OK, good point.

Paul
