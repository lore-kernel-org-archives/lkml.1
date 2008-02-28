Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYB1FS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYB1FS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYB1FSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:18:14 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbYB1FSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:18:13 -0500
Date: Wed, 27 Feb 2008 21:17:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4] autofs4 - add mount option to display mount device
Message-Id: <20080227211756.9e57e8a6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802261219500.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	<Pine.LNX.4.64.0802261219500.8490@raven.themaw.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 13:29:07 +0900 (WST) Ian Kent <raven@themaw.net> wrote:

> --- linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.add-mount-device-display-option	2008-02-20 13:01:06.000000000 +0900
> +++ linux-2.6.25-rc2-mm1/fs/autofs4/inode.c	2008-02-20 13:03:45.000000000 +0900
> @@ -190,6 +190,7 @@ static int autofs4_show_options(struct s
>  	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
>  	seq_printf(m, ",minproto=%d", sbi->min_proto);
>  	seq_printf(m, ",maxproto=%d", sbi->max_proto);
> +	seq_printf(m, ",dev=%d", autofs4_get_dev(sbi));

%u would be more appropriate here.
