Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZBQMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZBQMdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZBQMdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:33:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:37359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBQMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:33:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=J/EChjo9zz1UyoGwqdZH26NXLsBA0xLcrdAJ/87WWdx/865ZBw9JkXgQK8aZDQsurP
         ay2eXAVCT1bhbfS8A2FlGPn2FXy+wu6Ip+HXBGWb4Fj6BhSIcjBJjS2Zj7doRYusNUUT
         SHA32Q/jrqR5PzH5I2+QPrfYM1B9e54B8KKHk=
MIME-Version: 1.0
In-Reply-To: <1234871651.4744.89.camel@laptop>
References: <1234863220.4744.34.camel@laptop> <499A99BC.2080700@bk.jp.nec.com>
	 <20090217201651.576E.A69D9226@jp.fujitsu.com>
	 <1234871651.4744.89.camel@laptop>
Date: Tue, 17 Feb 2009 21:33:00 +0900
X-Google-Sender-Auth: 72d386d106bd34d8
Message-ID: <2f11576a0902170433x52b63a05ie96601c741c3fc7a@mail.gmail.com>
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you want to see I/O activity, you need to add tracepoint into block
>> layer.
>
> We already have that, Arnaldo converted blktrace to use tracepoints and
> wrote an ftrace tracer for it.

Yup. I agree I selected wrong word.
My point is, if he want to know I/O delaying reason, the number of the
cache pages seems unrelated thing.
