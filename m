Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZHTClq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZHTClq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZHTClp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:41:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31528 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZHTClo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:41:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VALvbZ5grE/Lir6zzSWFJLux0SWUlU00EeeGPUXCUiM+hHx7VtLzKCePpw12A73ma
	2NijQKHA5LOXE0PnK3w0w==
MIME-Version: 1.0
In-Reply-To: <4A8CB62F.8030504@cn.fujitsu.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
	 <4A8CB62F.8030504@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 19:41:41 -0700
Message-ID: <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 7:34 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> It's sure that reverting this commit makes things easier, but
> rebasing this patchset shouldn't be hard. And this doesn't
> sound a good reason to revert an innocent commit.
>

The problem is that Ben's patch set starts with a patch that adds the
"procs" file, and then a patch that fixes the namespace bug, and he
and you used different names for variables/functions even though you
were doing essentially the same thing. So rebasing would involve
pretty much entirely rewriting the first patch and ditching the second
- not just a case of fixing up some merge conflicts.

Paul
