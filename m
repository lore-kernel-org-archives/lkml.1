Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZD2F7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZD2F7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZD2F7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:59:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:24328 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZD2F7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o7wblg2+gXDbOoK2wvPy74XHec0CS/nGlrLeshV+7C5d03ZN9QzPtqKg/rLnV7B7gu
         ofxSLw7rM0Zie1Y9jN0xpOSY7w5eO3e8RHInPnS16w5HMWfQULGDf+wNLgn68wSqtBoO
         9u30ud0Bx/+5XfC/1DQynZYok4Cp8nk0v1NAY=
MIME-Version: 1.0
In-Reply-To: <20090428223624.61e7b255.akpm@linux-foundation.org>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu>
	 <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
	 <20090428223624.61e7b255.akpm@linux-foundation.org>
Date: Wed, 29 Apr 2009 15:59:19 +1000
Message-ID: <21d7e9970904282259w367c6964ve6fbec9e37771bc0@mail.gmail.com>
Subject: Re: kms in defconfig
From: Dave Airlie <airlied@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 3:36 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 27 Apr 2009 18:56:27 +1000 Dave Airlie <airlied@gmail.com> wrote:
>
>> > KMS is the sane design for graphics and i'd go as far as to consider
>> > user-space mode setting an outright _bug_. It look a long time to
>> > fix but now lets look forward and fix all the bugs in KMS, ASAP ...
>>
>> Its mainly for things like Andrews Vaio, people will not expect a new kernel
>> to take out any current userspace, its a pain, but we assume distros + people
>> who compile their own kernels will know what userspace exists on their
>> machines and other will get the least surprise.
>
> My Vaio thanks you.
>
> What is the expected user-visible failure mode when someone enables KMS
> on naive userspace?  iow, how can bug report screeners recognise when this has
> happened?
>
>

Generally X doesn't start, or X starts but dies soon after, so its
fairly easy to nail down from
xorg log file and dmesg.

Dave.
