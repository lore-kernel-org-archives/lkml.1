Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYEESZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYEESZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbYEESYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:24:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbYEESYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:24:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vdmyxFrJdZQ0I9kEFjTZnLGXG1TGYYs0eFPFvWDndIMgyoJaQaVe34he295i3fmTH
	Gbq53e3R5seZqelLR0DEw==
Message-ID: <6599ad830805051124t6f0fce0bu510adb7718c42a20@mail.gmail.com>
Date: Mon, 5 May 2008 11:24:11 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] make cgroup_seqfile_release() static
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080505182154.GF17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182154.GF17139@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 11:21 AM, Adrian Bunk <bunk@kernel.org> wrote:
> cgroup_seqfile_release() can become static.
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Paul Menage <menage@google.com>

Thanks,

Paul

>
>  ---
>  f08ef145219300d3279c37d22f29a22fcbcdd138 diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index b9d467d..ea4b8f1 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -1560,7 +1560,7 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
>         return cft->read_seq_string(state->cgroup, cft, m);
>   }
>
>  -int cgroup_seqfile_release(struct inode *inode, struct file *file)
>  +static int cgroup_seqfile_release(struct inode *inode, struct file *file)
>   {
>         struct seq_file *seq = file->private_data;
>         kfree(seq->private);
>
>
