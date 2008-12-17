Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760236AbYLQIBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYLQIBW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLQIBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:01:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27669 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLQIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:01:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=keG5SnLlj/LLAgUwgQIHsImCSnYIffZuYcPbQpJs6+N6f9Kh7FEEgBUt4ckXZ/tC8
	aeduhCHxW54cxN08lLnWA==
MIME-Version: 1.0
In-Reply-To: <494852FA.3000101@cn.fujitsu.com>
References: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
	 <494852FA.3000101@cn.fujitsu.com>
Date: Wed, 17 Dec 2008 00:01:05 -0800
Message-ID: <6599ad830812170001wfca7cd0n15e5ead3a569f2c2@mail.gmail.com>
Subject: Re: [PATCH] Make cgroup_path() RCU-safe
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 5:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> But the patch is word wrapped..

Sigh. I thought that I'd fixed gmail to not do that ...

I'll try to resend.

>
> We already have kernel-doc for cgroup_path(), why do we need those comments
> in cgroup.h.
>

Fair point - I got rid of those extra comments.

Paul
