Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698Ab0AVQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0AVQ2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614Ab0AVQ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:28:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab0AVQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:28:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=jNYg3Top3PJpTWq1RhotqFmNEXLdQiT9zYuAp6gaSVNGVtHXOOyddBvP1s1w+QfIa
	WYODiz64RnmcuFE89Sz+Q==
MIME-Version: 1.0
In-Reply-To: <1264177353.4283.1541.camel@laptop>
References: <20100122155044.391857484@chello.nl>
	 <20100122155535.887853503@chello.nl>
	 <bd4cb8901001220808n6f731d79m7195eea8e16f57d4@mail.gmail.com>
	 <1264177353.4283.1541.camel@laptop>
Date: Fri, 22 Jan 2010 17:28:36 +0100
Message-ID: <bd4cb8901001220828x40018249u5ffc8dfa8c2b7448@mail.gmail.com>
Subject: Re: [PATCH 08/10] perf_event: Optimize the constraint searching bits
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu, davem@davemloft.net,
       robert.richter@amd.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 5:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-01-22 at 17:08 +0100, Stephane Eranian wrote:
>> On Fri, Jan 22, 2010 at 4:50 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > Instead of copying bitmasks around, pass pointers to the constraint structure.
>> >
>> The reason I changed that is because of the AMD situation where constraints
>> are dynamically generated. So we need to get some storage from somwhere.
>> See my AMD NB patch,
>
> Can't we still do that by embedding 4 event_constraint structures in
> struct amd_nb and rewriting those as we need?
>
We sure could do that too.
