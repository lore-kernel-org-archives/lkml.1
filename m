Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686Ab0ABPJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0ABPJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492Ab0ABPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:09:33 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53466 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0ABPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tzMRbBvTq55CZ7ajGLzfbauVdQQpZoEf3u9nkcsKYm6BI0rN5gDUGt41KgvF+a+QFx
         XLELL55WQUd9kg87Zck8Ecwca7vCxSbOsqLxPLCQJY7mtj91JM0QxjdnP6bU0zsqjjS1
         Ot9k/obFDGvzcEwhDCZum8Zob2nAMDWMznTgY=
MIME-Version: 1.0
In-Reply-To: <1262443500.6408.3.camel@laptop>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
	 <1262387986.16572.234.camel@laptop>
	 <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
	 <1262429166.32223.32.camel@laptop>
	 <2f11576a1001020529l729caebawc4364690f1df56cb@mail.gmail.com>
	 <1262443500.6408.3.camel@laptop>
Date: Sun, 3 Jan 2010 00:09:32 +0900
X-Google-Sender-Auth: 6c18b8d51dcdcfaa
Message-ID: <2f11576a1001020709m106b16fcqa15ee41a1a8e22a@mail.gmail.com>
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim too
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/2 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2010-01-02 at 22:29 +0900, KOSAKI Motohiro wrote:
>
>> When recursive annotation occur?
>
> Dunno, I told you you'd have to make sure it doesn't.

Please see PF_MEMALLOC turning on/off operation points. all
PF_MEMALLOC turing on point prevent recersive already.
(because, otherwise we lost PF_MEMALLOC and makes deadlock...)
