Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZHTCpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZHTCpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZHTCpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:45:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZHTCpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:45:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=e67z+0IsBzIWouf6V0hAokh75uIen+a8jc9Zm9Jo6/eFMbCzgjyQEY1Vlznw7unP3
	upUkybtA+x5VEBCIdcG/A==
MIME-Version: 1.0
In-Reply-To: <4A8CB750.7040509@cn.fujitsu.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
	 <4A8CB750.7040509@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 19:45:11 -0700
Message-ID: <6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD 
	fork()ing per-threadgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 7:39 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
>> +             list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
>> +                     if (p->sighand) {
>> +                             sighand = tsk->sighand;
>
> s/tsk->sighand/p->sighand

Good catch, thanks. Fixed.

Paul
