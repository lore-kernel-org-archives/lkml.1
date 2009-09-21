Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZIUWdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZIUWdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZIUWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:33:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZIUWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:33:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=IUbSD0hSJaXQM7xzU3dgVhwQIDXEs2MADmWApkZKkl9ilGwRtUS9h5A4n0hfs1AoF
	I9IlzmEhSb98AgsjNYgeg==
MIME-Version: 1.0
In-Reply-To: <20090921091759.GF4649@osiris.boeblingen.de.ibm.com>
References: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
	 <20090921090627.GD4649@osiris.boeblingen.de.ibm.com>
	 <20090921091759.GF4649@osiris.boeblingen.de.ibm.com>
Date: Mon, 21 Sep 2009 15:33:06 -0700
Message-ID: <6599ad830909211533o65c1dab0gfe329cb063d76512@mail.gmail.com>
Subject: Re: [PATCH] Always show Cpus_allowed field in /proc/<pid>/status.
From: Paul Menage <menage@google.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 2:17 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Mon, Sep 21, 2009 at 11:06:27AM +0200, Heiko Carstens wrote:
>
>> +void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
>
> sigh. This should have been static.. updated patch below.
>
>
> Subject: [PATCH] Always show Cpus_allowed fields in /proc/<pid>/status.
>
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> The Cpus_allowed fields in /proc/<pid>/status is currently only shown in
> case of CONFIG_CPUSETS. However their contents are also useful for the
> !CONFIG_CPUSETS case.
> So change the current behaviour and always show these fields.
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Paul Menage <menage@google.com>

Sounds reasonable.
